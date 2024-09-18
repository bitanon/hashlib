// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:isolate';
import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/src/uuid.dart';
import 'package:test/test.dart';

@pragma('vm:entry-point')
void runIsolate(inp) {
  final port = inp[0] as SendPort;
  switch (inp[1] as String) {
    case 'v1':
      return port.send(uuid.v1());
    case 'v3':
      return port.send(uuid.v3());
    case 'v4':
      return port.send(uuid.v4());
    case 'v5':
      return port.send(uuid.v5());
    case 'v6':
      return port.send(uuid.v6());
    case 'v7':
      return port.send(uuid.v7());
    case 'v8':
      return port.send(uuid.v8());
  }
  throw ArgumentError('Undefined version');
}

void main() {
  group('UUID v1', () {
    test("known value", () {
      final time = DateTime.parse('2022-02-22T14:22:22-0500').toUtc();
      final clockSeq = 0x33C8;
      final node = 0x9F6BDECED846;
      final out = 'c232ab00-9414-11ec-b3c8-9f6bdeced846';
      final res = uuid.v1(node: node, clockSeq: clockSeq, utc: time);
      expect(res, equals(out));
    });
    test('uniqueness with futures', () async {
      final seeds = await Future.wait(List.generate(
        1000,
        (_) => Future.microtask(uuid.v1),
      ));
      expect(seeds.toSet().length, 1000);
    });

    test('uniqueness with isolates', () async {
      final receiver = ReceivePort();
      await Future.wait(List.generate(
        100,
        (_) => Isolate.spawn(
          runIsolate,
          [receiver.sendPort, 'v1'],
          errorsAreFatal: true,
        ),
      ));
      final items = await receiver.take(100).toList();
      expect(items.toSet().length, 100);
    }, tags: ['vm-only'], timeout: Timeout(Duration(minutes: 5)));
  });

  group('UUID v3', () {
    test("known value", () {
      final namespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
      final name = 'www.example.com';
      final out = '5df41881-3aed-3515-88a7-2f4a814cf09e';
      final res = uuid.v3(name: name, namespace: namespace);
      expect(res, equals(out));
    });
    test('uniqueness with futures', () async {
      final seeds = await Future.wait(List.generate(
        1000,
        (_) => Future.microtask(uuid.v3),
      ));
      expect(seeds.toSet().length, 1000);
    });

    test('uniqueness with isolates', () async {
      final receiver = ReceivePort();
      await Future.wait(List.generate(
        100,
        (_) => Isolate.spawn(
          runIsolate,
          [receiver.sendPort, 'v3'],
          errorsAreFatal: true,
        ),
      ));
      final items = await receiver.take(100).toList();
      expect(items.toSet().length, 100);
    }, tags: ['vm-only'], timeout: Timeout(Duration(minutes: 5)));
  });

  group('UUID v4', () {
    test("known value", () {
      final out = RegExp(r'........-....-4...-....-............');
      final res = uuid.v4();
      expect(res, matches(out));
      final part4 = fromHex(res.split('-')[3]).buffer.asUint8List();
      expect(part4[0] >>> 6, 2);
    });
    test('uniqueness with futures', () async {
      final seeds = await Future.wait(List.generate(
        1000,
        (_) => Future.microtask(uuid.v4),
      ));
      expect(seeds.toSet().length, 1000);
    });

    test('uniqueness with isolates', () async {
      final receiver = ReceivePort();
      await Future.wait(List.generate(
        100,
        (_) => Isolate.spawn(
          runIsolate,
          [receiver.sendPort, 'v4'],
          errorsAreFatal: true,
        ),
      ));
      final items = await receiver.take(100).toList();
      expect(items.toSet().length, 100);
    }, tags: ['vm-only'], timeout: Timeout(Duration(minutes: 5)));
  });

  group('UUID v5', () {
    test("known value", () {
      final namespace = '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
      final name = 'www.example.com';
      final out = '2ed6657d-e927-568b-95e1-2665a8aea6a2';
      final res = uuid.v5(name: name, namespace: namespace);
      expect(res, equals(out));
    });
    test('uniqueness with futures', () async {
      final seeds = await Future.wait(List.generate(
        1000,
        (_) => Future.microtask(uuid.v5),
      ));
      expect(seeds.toSet().length, 1000);
    });

    test('uniqueness with isolates', () async {
      final receiver = ReceivePort();
      await Future.wait(List.generate(
        100,
        (_) => Isolate.spawn(
          runIsolate,
          [receiver.sendPort, 'v5'],
          errorsAreFatal: true,
        ),
      ));
      final items = await receiver.take(100).toList();
      expect(items.toSet().length, 100);
    }, tags: ['vm-only'], timeout: Timeout(Duration(minutes: 5)));
  });

  group('UUID v6', () {
    test("known value", () {
      final time = DateTime.parse('2022-02-22T14:22:22-0500').toUtc();
      final clockSeq = 0x33C8;
      final node = 0x9F6BDECED846;
      final out = '1ec9414c-232a-6b00-b3c8-9f6bdeced846';
      final res = uuid.v6(node: node, clockSeq: clockSeq, utc: time);
      expect(res, equals(out));
    });
    test('uniqueness with futures', () async {
      final seeds = await Future.wait(List.generate(
        1000,
        (_) => Future.microtask(uuid.v6),
      ));
      expect(seeds.toSet().length, 1000);
    });

    test('uniqueness with isolates', () async {
      final receiver = ReceivePort();
      await Future.wait(List.generate(
        100,
        (_) => Isolate.spawn(
          runIsolate,
          [receiver.sendPort, 'v6'],
          errorsAreFatal: true,
        ),
      ));
      final items = await receiver.take(100).toList();
      expect(items.toSet().length, 100);
    }, tags: ['vm-only'], timeout: Timeout(Duration(minutes: 5)));
  });

  group('UUID v7', () {
    test("known value", () {
      final time = DateTime.parse('2022-02-22T14:22:22-0500').toUtc();
      final out = RegExp(r'017f22e2-79b0-7...-....-............');
      final res = uuid.v7(utc: time);
      expect(res, matches(out));
      final part4 = fromHex(res.split('-')[3]).buffer.asUint8List();
      expect(part4[0] >>> 6, 2);
    });
    test('uniqueness with futures', () async {
      final seeds = await Future.wait(List.generate(
        1000,
        (_) => Future.microtask(uuid.v7),
      ));
      expect(seeds.toSet().length, 1000);
    });

    test('uniqueness with isolates', () async {
      final receiver = ReceivePort();
      await Future.wait(List.generate(
        100,
        (_) => Isolate.spawn(
          runIsolate,
          [receiver.sendPort, 'v7'],
          errorsAreFatal: true,
        ),
      ));
      final items = await receiver.take(100).toList();
      expect(items.toSet().length, 100);
    }, tags: ['vm-only'], timeout: Timeout(Duration(minutes: 5)));
  });

  group('UUID v8', () {
    test("known value 1", () {
      final nonce = fromHex('2489E9AD2EE20E000EC932D5F69181C0');
      final out = '2489e9ad-2ee2-8e00-8ec9-32d5f69181c0';
      final res = uuid.v8(nonce: nonce);
      expect(res, equals(out));
    });
    test("known value 2", () {
      final nonce = fromHex('5c146b143c524afd938a375d0df1fbf6');
      final out = '5c146b14-3c52-8afd-938a-375d0df1fbf6';
      final res = uuid.v8(nonce: nonce);
      expect(res, equals(out));
    });
    test("throws argument error on invalid nonce", () {
      for (int i = 0; i < 20; ++i) {
        final nonce = Uint8List(i);
        if (i == 16) {
          uuid.v8(nonce: nonce);
        } else {
          expect(
            () => uuid.v8(nonce: nonce),
            throwsArgumentError,
            reason: 'length: $i',
          );
        }
      }
    });
    test('uniqueness with futures', () async {
      final seeds = await Future.wait(List.generate(
        1000,
        (_) => Future.microtask(uuid.v8),
      ));
      expect(seeds.toSet().length, 1000);
    });

    test('uniqueness with isolates', () async {
      final receiver = ReceivePort();
      await Future.wait(List.generate(
        100,
        (_) => Isolate.spawn(
          runIsolate,
          [receiver.sendPort, 'v8'],
          errorsAreFatal: true,
        ),
      ));
      final items = await receiver.take(100).toList();
      expect(items.toSet().length, 100);
    }, tags: ['vm-only'], timeout: Timeout(Duration(minutes: 5)));
  });

  group('NamespaceValue', () {
    final matcher = matches('........-....-....-....-............');
    test('dns', () {
      expect(Namespace.dns.value, matcher);
    });
    test('url', () {
      expect(Namespace.url.value, matcher);
    });
    test('oid', () {
      expect(Namespace.oid.value, matcher);
    });
    test('x500', () {
      expect(Namespace.x500.value, matcher);
    });
    test('nil', () {
      expect(Namespace.nil.value, matcher);
    });
    test('max', () {
      expect(Namespace.max.value, matcher);
    });
    test('time', () {
      expect(Namespace.time.value, matcher);
    });
  });
}
