// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'package:xrandom/src/20_seeding.dart';
import 'package:xrandom/src/21_base32.dart';

import '00_ints.dart';

/// Random number generator based on **xorshift128** algorithm by G. Marsaglia.
///
/// [reference](https://www.jstatsoft.org/article/view/v008i14)
class Xorshift128 extends RandomBase32 {
  Xorshift128([int? a, int? b, int? c, int? d]) {
    if (a != null || b != null || c != null || d != null) {
      RangeError.checkValueInInterval(a!, 0, UINT32_MAX);
      RangeError.checkValueInInterval(b!, 0, UINT32_MAX);
      RangeError.checkValueInInterval(c!, 0, UINT32_MAX);
      RangeError.checkValueInInterval(d!, 0, UINT32_MAX);

      if (a == 0 && b == 0 && c == 0 && d == 0) {
        throw ArgumentError('The seed should not consist of only zeros..');
      }

      _a = a;
      _b = b;
      _c = c;
      _d = d;
    } else {
      final now = DateTime.now().microsecondsSinceEpoch;
      // just creating a mess

      _a = mess2to64A(now, this.hashCode) & 0xFFFFFFFF;
      _b = mess2to64B(now, this.hashCode) & 0xFFFFFFFF;
      _c = mess2to64C(now, this.hashCode) & 0xFFFFFFFF;
      _d = mess2to64D(now, this.hashCode) & 0xFFFFFFFF;
    }
  }
  late int _a, _b, _c, _d;

  @override
  int nextRaw32() {
    // algorithm from p.5 of "Xorshift RNGs"
    // by George Marsaglia, 2003
    // https://www.jstatsoft.org/article/view/v008i14
    //
    // rewritten for Dart from snippet
    // found at https://en.wikipedia.org/wiki/Xorshift

    var t = _d;
    final s = _a;
    _d = _c;
    _c = _b;
    _b = s;

    t ^= t << 11;
    t &= 0xFFFFFFFF;

    // rewritten `t ^= t.unsignedRightShift(8); //t ^= t >> 8;`
    t ^= (t >> 8) & ~(-1 << (64 - 8));

    _a = t ^ s ^ (s >> 19);
    _a &= 0xFFFFFFFF;

    return _a;
  }

  static Xorshift128 seeded() {
    return Xorshift128(0xd5dcc73b, 0x39398022, 0x91537a66, 0x6cb3accc);
  }
}
