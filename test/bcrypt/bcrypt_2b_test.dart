// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  // https://github.com/pyca/bcrypt/blob/main/tests/test_bcrypt.py
  group('bcrypt version 2b', () {
    test(r"$2b$04$cVWp4XaNU8a4v1uMRum2SO026BWLIoQMD/TXg5uZV.0P.uO8m3YEm", () {
      var password = "Kk4DQuMMfZL9o";
      var encoded =
          r"$2b$04$cVWp4XaNU8a4v1uMRum2SO026BWLIoQMD/TXg5uZV.0P.uO8m3YEm";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$pQ7gRO7e6wx/936oXhNjrOUNOHL1D0h1N2IDbJZYs.1ppzSof6SPy", () {
      var password = "9IeRXmnGxMYbs";
      var encoded =
          r"$2b$04$pQ7gRO7e6wx/936oXhNjrOUNOHL1D0h1N2IDbJZYs.1ppzSof6SPy";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$SQe9knOzepOVKoYXo9xTteNYr6MBwVz4tpriJVe3PNgYufGIsgKcW", () {
      var password = "xVQVbwa1S0M8r";
      var encoded =
          r"$2b$04$SQe9knOzepOVKoYXo9xTteNYr6MBwVz4tpriJVe3PNgYufGIsgKcW";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$eH8zX.q5Q.j2hO1NkVYJQOM6KxntS/ow3.YzVmFrE4t//CoF4fvne", () {
      var password = "Zfgr26LWd22Za";
      var encoded =
          r"$2b$04$eH8zX.q5Q.j2hO1NkVYJQOM6KxntS/ow3.YzVmFrE4t//CoF4fvne";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$ahiTdwRXpUG2JLRcIznxc.s1.ydaPGD372bsGs8NqyYjLY1inG5n2", () {
      var password = "Tg4daC27epFBE";
      var encoded =
          r"$2b$04$ahiTdwRXpUG2JLRcIznxc.s1.ydaPGD372bsGs8NqyYjLY1inG5n2";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$nQn78dV0hGHf5wUBe0zOFu8n07ZbWWOKoGasZKRspZxtt.vBRNMIy", () {
      var password = "xhQPMmwh5ALzW";
      var encoded =
          r"$2b$04$nQn78dV0hGHf5wUBe0zOFu8n07ZbWWOKoGasZKRspZxtt.vBRNMIy";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$cvXudZ5ugTg95W.rOjMITuM1jC0piCl3zF5cmGhzCibHZrNHkmckG", () {
      var password = "59je8h5Gj71tg";
      var encoded =
          r"$2b$04$cvXudZ5ugTg95W.rOjMITuM1jC0piCl3zF5cmGhzCibHZrNHkmckG";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$YYjtiq4Uh88yUsExO0RNTuEJ.tZlsONac16A8OcLHleWFjVawfGvO", () {
      var password = "wT4fHJa2N9WSW";
      var encoded =
          r"$2b$04$YYjtiq4Uh88yUsExO0RNTuEJ.tZlsONac16A8OcLHleWFjVawfGvO";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$WLTjgY/pZSyqX/fbMbJzf.qxCeTMQOzgL.CimRjMHtMxd/VGKojMu", () {
      var password = "uSgFRnQdOgm4S";
      var encoded =
          r"$2b$04$WLTjgY/pZSyqX/fbMbJzf.qxCeTMQOzgL.CimRjMHtMxd/VGKojMu";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$2moPs/x/wnCfeQ5pCheMcuSJQ/KYjOZG780UjA/SiR.KsYWNrC7SG", () {
      var password = "tEPtJZXur16Vg";
      var encoded =
          r"$2b$04$2moPs/x/wnCfeQ5pCheMcuSJQ/KYjOZG780UjA/SiR.KsYWNrC7SG";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$HrEYC/AQ2HS77G78cQDZQ.r44WGcruKw03KHlnp71yVQEwpsi3xl2", () {
      var password = "vvho8C6nlVf9K";
      var encoded =
          r"$2b$04$HrEYC/AQ2HS77G78cQDZQ.r44WGcruKw03KHlnp71yVQEwpsi3xl2";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$vVYgSTfB8KVbmhbZE/k3R.ux9A0lJUM4CZwCkHI9fifke2.rTF7MG", () {
      var password = "5auCCY9by0Ruf";
      var encoded =
          r"$2b$04$vVYgSTfB8KVbmhbZE/k3R.ux9A0lJUM4CZwCkHI9fifke2.rTF7MG";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$JfoNrR8.doieoI8..F.C1OQgwE3uTeuardy6lw0AjALUzOARoyf2m", () {
      var password = "GtTkR6qn2QOZW";
      var encoded =
          r"$2b$04$JfoNrR8.doieoI8..F.C1OQgwE3uTeuardy6lw0AjALUzOARoyf2m";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$HP3I0PUs7KBEzMBNFw7o3O7f/uxaZU7aaDot1quHMgB2yrwBXsgyy", () {
      var password = "zKo8vdFSnjX0f";
      var encoded =
          r"$2b$04$HP3I0PUs7KBEzMBNFw7o3O7f/uxaZU7aaDot1quHMgB2yrwBXsgyy";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$xnFVhJsTzsFBTeP3PpgbMeMREb6rdKV9faW54Sx.yg9plf4jY8qT6", () {
      var password = "I9VfYlacJiwiK";
      var encoded =
          r"$2b$04$xnFVhJsTzsFBTeP3PpgbMeMREb6rdKV9faW54Sx.yg9plf4jY8qT6";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$WQp9.igoLqVr6Qk70mz6xuRxE0RttVXXdukpR9N54x17ecad34ZF6", () {
      var password = "VFPO7YXnHQbQO";
      var encoded =
          r"$2b$04$WQp9.igoLqVr6Qk70mz6xuRxE0RttVXXdukpR9N54x17ecad34ZF6";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$xgZtlonpAHSU/njOCdKztOPuPFzCNVpB4LGicO4/OGgHv.uKHkwsS", () {
      var password = "VDx5BdxfxstYk";
      var encoded =
          r"$2b$04$xgZtlonpAHSU/njOCdKztOPuPFzCNVpB4LGicO4/OGgHv.uKHkwsS";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$2Siw3Nv3Q/gTOIPetAyPr.GNj3aO0lb1E5E9UumYGKjP9BYqlNWJe", () {
      var password = "dEe6XfVGrrfSH";
      var encoded =
          r"$2b$04$2Siw3Nv3Q/gTOIPetAyPr.GNj3aO0lb1E5E9UumYGKjP9BYqlNWJe";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$7/Qj7Kd8BcSahPO4khB8me4ssDJCW3r4OGYqPF87jxtrSyPj5cS5m", () {
      var password = "cTT0EAFdwJiLn";
      var encoded =
          r"$2b$04$7/Qj7Kd8BcSahPO4khB8me4ssDJCW3r4OGYqPF87jxtrSyPj5cS5m";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$04$VvlCUKbTMjaxaYJ.k5juoecpG/7IzcH1AkmqKi.lIZMVIOLClWAk.", () {
      var password = "J8eHUDuxBB520";
      var encoded =
          r"$2b$04$VvlCUKbTMjaxaYJ.k5juoecpG/7IzcH1AkmqKi.lIZMVIOLClWAk.";
      var output = bcrypt(utf8.encode(password), encoded);
      expect(output, equals(encoded));
    });

    test(r"$2b$10$keO.ZZs22YtygVF6BLfhGOI/JjshJYPp8DZsUtym6mJV2Eha2Hdd.", () {
      var password = [
        125, 62, 179, 254, 241, 139, 160, 230, 40, 162, 76, 122, 113, 195, //
        80, 127, 204, 200, 98, 123, 249, 20, 246, 246, 96, 129, 71, 53, 236,
        29, 135, 16, 191, 167, 225, 125, 73, 55, 32, 150, 223, 99, 242, 191,
        179, 86, 104, 223, 77, 136, 113, 247, 255, 27, 130, 126, 122, 19, 221,
        233, 132, 0, 221, 52
      ];
      var encoded =
          r"$2b$10$keO.ZZs22YtygVF6BLfhGOI/JjshJYPp8DZsUtym6mJV2Eha2Hdd.";
      var output = bcrypt(password, encoded);
      expect(output, equals(encoded));
    });
  });
}
