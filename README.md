![Generic badge](https://img.shields.io/badge/status-draft-red.svg)
[![Actions Status](https://github.com/rtmigo/xorshift/workflows/unittest/badge.svg?branch=master)](https://github.com/rtmigo/xorshift/actions)
![Generic badge](https://img.shields.io/badge/tested_on-Windows_|_MacOS_|_Ubuntu-blue.svg)
![Generic badge](https://img.shields.io/badge/tested_on-VM_|_JS-blue.svg)

# [xorshift](https://github.com/rtmigo/xorshift)

This library implements [Xorshift](https://en.wikipedia.org/wiki/Xorshift) random number generators
in Dart.

Xorshift algorithms are known among the **fastest random number generators**, requiring very small
code and state.

# Speed

Generating 100 million of random numbers. Lower is better. Time is in milliseconds.

| Class              | nextInt | nextDouble | nextBool | nextInt32 | nextInt64 | nextDoubleFast |
|--------------------|---------|------------|----------|-----------|-----------|----------------|
| Random (dart:math) |  2392   |    3170    |   2281   |     -     |     -     |       -        |
| Xorshift32         |  1246   |    1856    |   1460   |    765    |     -     |      679       |
| Xorshift64         |  1944   |    3023    |   1350   |   1311    |   1371    |      1373      |
| Xorshift128        |  1821   |    3202    |   1497   |   1399    |     -     |      1323      |
| Xorshift128Plus    |  2046   |    3025    |   1402   |   1392    |   1489    |      1399      |

The benchmark was compiled to native. Executed on AMD A9-9420e with Ubuntu 20.04.

# Determinism

Xorshift's classes have a `deterministic` method. By creating like that, you'll get same 
sequence of numbers every time.

``` dart
test('my test', () {
    final predictablyRandom = Xorshift.deterministic();
    // results based on randoms are predictable now
    expect(predictablyRandom.nextInt(1000), 543);
    expect(predictablyRandom.nextInt(1000), 488);
    expect(predictablyRandom.nextInt(1000), 284);    
});    
```

You can achieve the same by creating the `Random` with a `seed` argument. However, the unchangeable
seed does not protect you from `dart:math` implementation updates. In contrast to this,
Xorshift is a very specific algorithm. Therefore, the predictability of the
Xorshift's `deterministic`
sequences can be relied upon. *(but not until the library reaches stable release status)*

# Usage

All classes implement the standard `Random` from `dart:math`, so they can be used in the same way.

``` dart
import 'package:xorshift/xorshift.dart';

Random random = Xorshift();
print(random.nextInt(100));
print(random.nextDouble());
```

In addition, they have a `next32()` method that returns an unsigned 32-bit value stored in `int`.
Some classes also have `next64()`. It returns 64-bit random signed `int`. The 64-bit numbers are only
supported on platforms other than JavaScript.

# Compatibility

| Class                            | 64-bit platforms | JavaScript |
|----------------------------------|------------------|------------|
| `Xorshift` aka `Xorshift32`      | yes              | yes        |
| `Xorshift128`                    | yes              | yes        |
| `Xorshift64`                     | yes              | no         |
| `Xorshift128Plus`                | yes              | no         |

The library has been thoroughly tested to match reference numbers generated by C algorithms. The
sources in C are taken directly from scientific publications by George Marsaglia and Sebastiano Vigna,
the inventors of the algorithms. The Xorshift128+ results are also matched to reference values from
JavaScript [xorshift](https://github.com/AndreasMadsen/xorshift) library, that tested the 128+
similarly.

Testing is done in the GitHub Actions cloud on Windows, Ubuntu and macOS in VM and NODE modes.
 
# Classes

| Class             | Algorithm    | Author           | Year |
|-------------------|--------------|------------------|------|
| `Xorshift`        | xorshift32   | George Marsaglia | 2003 |
| `Xorshift32`      | xorshift32   | George Marsaglia | 2003 |
| `Xorshift64`      | xorshift64   | George Marsaglia | 2003 |
| `Xorshift128`     | xorshift128  | George Marsaglia | 2003 |
| `Xorshift128Plus` | xorshift128+ | Sebastiano Vigna | 2015 |

