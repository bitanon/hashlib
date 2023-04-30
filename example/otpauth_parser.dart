import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/codecs_base.dart';

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
  var algo = BlockHashRegistry.lookup(algorithm);
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
  var data = fromBase64(
    migrationUri
        .split('?')
        .last
        .split('&')
        .firstWhere((d) => d.startsWith('data='))
        .substring('data='.length),
  );

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
    secret = toBase32(data.skip(i).take(len));
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
    if (issuer.isNotEmpty) {
      params.add('issuer=$issuer');
    }
    params.add('secret=$secret');
    params.add('algorithm=$algorithm');
    params.add('digits=$digits');
    var url = Uri(
      scheme: 'otpauth',
      host: type,
      path: '/$label',
      query: params.join('&'),
    );
    result.add(url.toString());
  }
  return result;
}

void main(List<String> args) {
  var migration =
      "otpauth-migration://offline?data=CisKCi0qa15qYUYsI8wSDkV4YW1wbGU6U0hBNTEyGgdFeGFtcGxlIAMoAjACCisKCi0qa15qYUYsI8wSDkV4YW1wbGU6U0hBMjU2GgdFeGFtcGxlIAIoAjACCikKCi0qa15qYUYsI8wSDEV4YW1wbGU6U0hBMRoHRXhhbXBsZSABKAEwAgo2ChTOVmhVzwG2tOcUvJIqCZ+EnbS2qxIPRXhhbXBsZTpObyBBbGdvGgdFeGFtcGxlIAEoATACCjgKFM5WaFXPAba05xS8kioJn4SdtLarEhFFeGFtcGxlOk5vIFBlcmlvZBoHRXhhbXBsZSABKAEwAgo4ChTOVmhVzwG2tOcUvJIqCZ+EnbS2qxIRRXhhbXBsZTpObyBEaWdpdHMaB0V4YW1wbGUgASgBMAIKLwoUzlZoVc8BtrTnFLySKgmfhJ20tqsSEUV4YW1wbGU6Tm8gSXNzdWVyIAEoATACEAEYASAAKJjgucEE";
  var uris = deocdeMigations(migration);
  for (int i = 0; i < uris.length; ++i) {
    print(uris[i]);
    var totp = parse(uris[i]) as TOTP;
    totp.stream.listen((e) {
      if (i == 0) print('\nTime: ${DateTime.now()}\n' + ('-' * 40));
      var otp = e.toString().padLeft(totp.digits, '0');
      var left = otp.substring(0, totp.digits ~/ 2);
      var right = otp.substring(totp.digits ~/ 2);
      var joined = '$left $right';
      if (totp.digits == 6) joined = ' $joined ';
      print('$joined <= ${totp.label}');
    });
  }
}
