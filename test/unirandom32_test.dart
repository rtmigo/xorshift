// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: MIT


import 'package:test/test.dart';
import 'package:xrandom/src/60_xorshift32.dart';

int nextInt_jdk(int Function() nextInt32, int n) {
  if (n <= 0) {
    throw RangeError('oops');
  }
  int bits, val;

  do {
    bits = nextInt32();
    val = bits % n;
  } while (bits - val + (n - 1) < 0);
  return val;
}

int nextInt_rewritten(int Function() nextInt32, int n) {
  if (n <= 0) {
    throw RangeError('oops');
  }
  int bits, val;
  do {
    bits = nextInt32();
    val = bits % n;
  } while (val - bits >= n);
  return val;
}


void main() {

  test('int from range returns expected (4)', () {
    final r = Xorshift32.seeded();
    expect(List.generate(20, (_) => r.nextInt(4)), [1, 2, 1, 0, 1, 2, 0, 1, 3, 0, 1, 2, 1, 1, 1, 1, 3, 2, 1, 2]);
  });

  test('int from range returns expected (4)', () {
    final r = Xorshift32.seeded();
    expect(List.generate(20, (_) => r.nextInt(2)), [1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0]);
  });

  test('int from range returns expected (1000)', () {
    final r = Xorshift32.seeded();
    expect(List.generate(20, (_) => r.nextInt(1000)), [
      925,
      686,
      509,
      612,
      81,
      578,
      328,
      773,
      955,
      780,
      945,
      438,
      521,
      897,
      501,
      773,
      351,
      578,
      861,
      582
    ]);
  });

  test('int from range returns expected 0xFFFFFFFF', () {
    final r = Xorshift32.seeded();
    expect(List.generate(20, (_) => r.nextInt(0xFFFFFFFF)), [
      1225539925,
      3858151686,
      1746562509,
      2446867612,
      1597309081,
      468565578,
      682730328,
      2274298773,
      3108930955,
      1443233780,
      3600443945,
      3762290438,
      3828952521,
      4052601897,
      1225903501,
      1688923773,
      365890351,
      1643691578,
      2982633861,
      3809083582
    ]);
  });

  test('nextRaw53', () {
    final r = Xorshift32.seeded();
    expect(List.generate(10, (_) => r.nextRaw53()), [
      2570143506677463,
      3662807060069127,
      3349799934066103,
      1431789273936353,
      6519900770844863,
      7550678221981695,
      8029895439299001,
      2570905979753821,
      767327682182935,
      6255036568723776
    ]);
  });

}
