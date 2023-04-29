import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';

/// Parse any otpauth URI
OTPAuth parse(String keyUri) {
  var uri = Uri.parse(keyUri);
  if (uri.scheme != 'otpauth') {
    throw ArgumentError('Invalid scheme: ${uri.scheme}. Expected: otpauth');
  }

  var query = uri.queryParameters;
  if (!query.containsKey('secret')) {
    throw ArgumentError('The secret parameter is not present');
  }
  var secret = fromBase32(query['secret']!);

  var algorithm = query['algorithm'] ?? 'SHA1';
  var algo = BlockHashRegistry.findAlgorithm(algorithm);
  if (algo == null) {
    throw ArgumentError('No such algorithm found: $algorithm');
  }

  int digits = int.parse(query['digits'] ?? '6');
  if (digits < 6 || digits > 12) {
    throw StateError('Number of digits should be between 6 to 12');
  }

  var label = Uri.decodeComponent(uri.path.substring(1));
  var issuer = query['issuer'];
  if (issuer != null) {
    issuer = Uri.decodeComponent(issuer);
  }

  switch (uri.host.toLowerCase()) {
    case 'totp':
      int period = int.parse(query['period'] ?? '30');
      return TOTP(
        secret,
        algo: algo,
        digits: digits,
        period: period,
        label: label,
        issuer: issuer,
      );
    case 'hotp':
      if (!query.containsKey('counter')) {
        throw ArgumentError('The counter parameter is not present');
      }
      var counter = Uint8List(8);
      int c = int.parse(query['counter']!);
      for (int i = 7; i >= 0; --i, c >>>= 8) {
        counter[i] = c & 0xFF;
      }
      return HOTP(
        secret,
        digits: 6,
        counter: counter,
        algo: algo,
        label: label,
        issuer: issuer,
      );
    default:
      throw ArgumentError('Unknown type: ${uri.host}');
  }
}

/// Decode Google Authenticator migration codes
List<String> deocdeMigations(String migrationUri) {
  var uri = Uri.parse(migrationUri);
  if (uri.scheme != 'otpauth-migration') {
    throw ArgumentError('Invalid scheme: ${uri.scheme}. Expected: otpauth');
  }

  var query = uri.queryParameters;
  if (!query.containsKey('data')) {
    throw ArgumentError('The data parameter is not present');
  }
  var data = fromBase64(query['data']!);

  var result = <String>[];
  for (int i = 2, len; i < data.length; ++i) {
    if (!(data[i - 2] == 10 && data[i] == 10)) continue;

    String secret;
    String label = 'Unknown';
    String issuer = '';
    String algorithm = 'SHA1';
    String digits = '6';
    String type = 'totp';

    i++;
    len = data[i];
    i++;
    secret = toBase32(List<int>.generate(len, (j) => data[i + j]));
    i += len;

    bool release = false;
    while (i < data.length && !release) {
      switch (data[i]) {
        case 18:
          i++;
          len = data[i];
          i++;
          label = String.fromCharCodes(data.skip(i).take(len));
          i += len;
          break;
        case 26:
          i++;
          len = data[i];
          i++;
          issuer = String.fromCharCodes(data.skip(i).take(len));
          i += len;
          break;
        case 32:
          i++;
          if (data[i] == 2) {
            algorithm = 'SHA256';
          } else if (data[i] == 3) {
            algorithm = 'SHA512';
          } else if (data[i] == 4) {
            algorithm = 'MD5';
          } else {
            algorithm = 'SHA1';
          }
          i++;
          break;
        case 40:
          i++;
          if (data[i] == 2) {
            digits = '8';
          } else {
            digits = '6';
          }
          i++;
          break;
        case 48:
          i++;
          if (data[i] == 1) {
            type = 'hotp';
          } else {
            type = 'totp';
          }
          i++;
          break;
        default:
          release = true;
          break;
      }
    }

    if (label.isEmpty && issuer.isNotEmpty) {
      label = issuer;
    }
    var params = [];
    if (!issuer.isNotEmpty) {
      params.add('issuer=$issuer');
    }
    params.add('secret=$secret');
    params.add('algorithm=$algorithm');
    params.add('digits=$digits');
    var url = Uri(
      scheme: 'otpauth',
      host: type,
      path: '/$label',
      queryParameters: {
        'issuer': issuer,
        'secret': secret,
        'algorithm': algorithm,
        'digits': digits,
      },
    );
    result.add(url.toString());
  }
  return result;
}

void main(List<String> args) {
  var uri =
      'otpauth://totp/Example:Name?issuer=Example&secret=94NXQOVMOYCG64EKI7L4XBEK4NP0RQAB&algorithm=SHA1&digits=6&period=30';
  var totp = parse(uri) as TOTP;
  print(totp.current);

  var migration =
      'otpauth-migration://offline?data=CkkKFCQzVndkJUBzKC1CSzo1MSVOeiZTEiBFeGFtcGxlOiBlbWFtcGxlLmVtYWlsQGdtYWlsLmNvbRoJSUV4YW1wbGVTIAEoATACChoKCi0qa15qYUYsI8wSBlNhbXBsZSABKAEwAgo8ChRtA2tzEUZBJV4qMColcwpHNf9wTRIWQW5vdGhlciA6IFNhbXBsZSBMYWJlbBoGU2FtcGxlIAEoATACEAEYAiABKIaS4JIH';
  for (final uri in deocdeMigations(migration)) {
    var totp = parse(uri) as TOTP;
    totp.stream.listen((e) {
      var otp = e.toString().padLeft(totp.digits, '0');
      print('${totp.label} => $otp');
    });
  }
}
