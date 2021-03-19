// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import "package:test/test.dart";
import 'package:xrandom/src/60_xoshiro128pp.dart';

import 'helper.dart';

void main() {
  testCommonRandom(() => Xoshiro128pp(), ()=>Xoshiro128pp.seeded());
  checkReferenceFiles(() => Xoshiro128pp(1, 2, 3, 4), 'a');
  checkReferenceFiles(() => Xoshiro128pp(5, 23, 42, 777), 'b');
  checkReferenceFiles(
      () => Xoshiro128pp(1081037251, 1975530394, 2959134556, 1579461830), 'c');

  test('expected values', () {
    expect(expectedList(Xoshiro128pp.seeded()),
        [3992448746, 47897, 0.1329367530455241, false, true, false]);
  });
}
