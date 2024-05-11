// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

/// Represents an abstract class for implementing [One-Time Password (OTP)
/// authentication][rfc2289] methods in Dart.
///
/// This class provides a foundation for creating variable length OTP generation
/// algorithms. Subclasses must implement the [value] method to generate OTP
/// values based on a specific algorithm.
///
/// [rfc2289]: https://www.ietf.org/rfc/rfc2289.html
abstract class OTPAuth {
  /// The number of digits in the generated OTP
  final int digits;
  final String? label;
  final String? issuer;

  const OTPAuth(
    this.digits, {
    this.label,
    this.issuer,
  }) : assert(digits >= 4 && digits <= 15);

  /// Generates the OTP value
  int value();
}
