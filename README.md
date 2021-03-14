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

Generating 100 million of random numbers with AOT-compiled binary. 

| Time (lower is better) | nextInt | nextDouble | nextBool |
|------------------------|---------|------------|----------|
| Random (dart:math)     |  2323   |    3107    |   2264   |
| Xrandom                |  1269   |    1930    |   1467   |


# Simplicity

It's compatible with the standard [`Random`](https://api.dart.dev/stable/2.12.1/dart-math/Random-class.html)

``` dart
import 'package:xrandom/xrandom.dart';

Random xrandom = Xrandom();

var a = xrandom.nextBool(); 
var b = xrandom.nextDouble();
var c = xrandom.nextInt(n);
```

# Determinism

Xrandom's classes have a `deterministic` method. By creating the object like that, you'll get same 
sequence of numbers every time.

``` dart
test('my test', () {
    final xrandom = Xrandom.deterministic();
    // run this test twice ;)
    expect(xrandom.nextInt(1000), 119);
    expect(xrandom.nextInt(1000), 240);
    expect(xrandom.nextInt(1000), 369);    
});    
```

You can achieve about the same by creating the `Random` with a `seed` argument. However, the unchangeable
seed does not protect you from `dart:math` implementation updates. In contrast to this,
*xorshift32* is a very specific algorithm. Therefore, the predictability of the
Xorshift's `deterministic`
sequences can be relied upon. *(but not until the library reaches stable release status)*



# Compatibility

| Class                            | 64-bit platforms | JavaScript |
|----------------------------------|------------------|------------|
| **`Xrandom`** aka **`Xorshift32`**      | yes              | yes        |
| **`Xorshift128`**                    | yes              | yes        |
| **`Xoshiro128pp`**                   | yes              | yes         |
| `Xorshift64`                     | yes              | no         |
| `Xorshift128Plus`                | yes              | no         |


The library has been thoroughly **tested to match reference numbers** generated by C algorithms. The
sources in C are taken directly from scientific publications by George Marsaglia and Sebastiano
Vigna, the inventors of the algorithms. The Xorshift128+ results are also matched to reference
values from [JavaScript xorshift](https://github.com/AndreasMadsen/xorshift) library, that tested
the 128+ similarly.

Testing is done in the GitHub Actions cloud on **Windows**, **Ubuntu** and **macOS** in **VM** and **Node.js** modes.
 
# Classes

| Class             | Algorithm    | Algorithm author | Published |
|-------------------|--------------|------------------|------|
| `Xrandom`        | [xorshift32](https://www.jstatsoft.org/article/view/v008i14)   | G. Marsaglia | 2003 |
| `Xorshift32`      | [xorshift32](https://www.jstatsoft.org/article/view/v008i14)   | G. Marsaglia | 2003 |
| `Xorshift64`      | [xorshift64](https://www.jstatsoft.org/article/view/v008i14)   | G. Marsaglia | 2003 |
| `Xorshift128`     | [xorshift128](https://www.jstatsoft.org/article/view/v008i14)  | G. Marsaglia | 2003 |
| `Xorshift128Plus` | [xorshift128+](https://arxiv.org/abs/1404.0390) | S. Vigna | 2015 |
| `Xoshiro128pp` | [xoshiro128++ 1.0](https://prng.di.unimi.it/xoshiro128plusplus.c) | D. Blackman and S. Vigna | 2019 |

# Speed optimizations

The `nextDoubleFast()` is a lightning fast mapping of 32-bit integers to a `double` in reduced detail.

| Time (lower is better) | nextDouble | nextDoubleFast |
|------------------------|------------|----------------|
| Random (dart:math)     |    3107    |       -        |
| Xorshift32             |    1930    |      696       |
| Xorshift64             |    2164    |      1340      |
| Xorshift128            |    3164    |      1293      |
| Xorshift128Plus        |    3023    |      1373      |
| Xoshiro128pp           |    4535    |      2086      |

The `nextInt32()` and `nextInt64()` do not accept any arguments. They return the raw output of the RNGs.

``` dart 
var xrandom = Xorshift(); 
xrandom.nextInt32();  // 32-bit unsigned 
xrandom.nextInt64();  // 64-bit signed
```

| Time (lower is better) | nextInt | nextInt32 | nextInt64 |
|------------------------|---------|-----------|-----------|
| Random (dart:math)     |  2323   |     -     |     -     |
| Xorshift32             |  1269   |    767    |     -     |
| Xorshift64             |  1974   |   1292    |   1381    |
| Xorshift128            |  1967   |   1301    |     -     |
| Xorshift128Plus        |  2015   |   1364    |   1521    |
| Xoshiro128pp           |  2546   |   2048    |     -     |

# More benchmarks

| Time (lower is better) | nextInt | nextDouble | nextBool |
|------------------------|---------|------------|----------|
| Random (dart:math)     |  2323   |    3107    |   2264   |
| Xorshift32             |  1269   |    1930    |   1467   |
| Xorshift64             |  1974   |    2164    |   1393   |
| Xorshift128            |  1967   |    3164    |   1479   |
| Xorshift128Plus        |  2015   |    3023    |   1413   |
| Xoshiro128pp           |  2546   |    4535    |   1500   |

-----
All the benchmarks on this page are from AOT-compiled binaries running on AMD A9-9420e with Ubuntu 20.04.
Time is measured in milliseconds.
