// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

const int _zero = 48;
const int _nine = 57;
const int _smallA = 97;
const int _smallZ = 122;
const int _bigA = 65;
const int _bigZ = 90;

/// Remove all characters except digits
@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
String keepNumeric(String value) {
  return String.fromCharCodes(
    value.codeUnits.where(
      (c) => (c >= _zero && c <= _nine),
    ),
  );
}

/// Remove all characters except letters
@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
String keepAlpha(String value) {
  return String.fromCharCodes(
    value.codeUnits.where(
      (c) => (c >= _bigA && c <= _bigZ) || (c >= _smallA && c <= _smallZ),
    ),
  );
}

/// Remove all characters except letters and digits
@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
String keepAlphaNumeric(String value) {
  return String.fromCharCodes(
    value.codeUnits.where(
      (c) =>
          (c >= _zero && c <= _nine) ||
          (c >= _bigA && c <= _bigZ) ||
          (c >= _smallA && c <= _smallZ),
    ),
  );
}

/// Transform [value] to uppercase and keeps only letters and digits.
@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
String normalizeName(String value) {
  return String.fromCharCodes(() sync* {
    for (int c in value.codeUnits) {
      if ((c >= _zero && c <= _nine) || (c >= _bigA && c <= _bigZ)) {
        yield c;
      } else if (c >= _smallA && c <= _smallZ) {
        yield c - _smallA + _bigA;
      }
    }
  }());
}
