// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart' as hashlib;

import 'base.dart';

Random random = Random();

class XXH32Benchmark extends Benchmark {
  XXH32Benchmark(int size, int iter) : super('XXH32', size, iter);

  @override
  void run() {
    hashlib.xxh32.convert(input).bytes;
  }
}

class XXH64Benchmark extends Benchmark {
  XXH64Benchmark(int size, int iter) : super('XXH64', size, iter);

  @override
  void run() {
    hashlib.xxh64.convert(input).bytes;
  }
}

class XXH3Benchmark extends Benchmark {
  XXH3Benchmark(int size, int iter) : super('XXH3', size, iter);

  @override
  void run() {
    hashlib.xxh3.convert(input).bytes;
  }
}

class XXH128Benchmark extends Benchmark {
  XXH128Benchmark(int size, int iter) : super('XXH128', size, iter);

  @override
  void run() {
    hashlib.xxh128.convert(input).bytes;
  }
}

void main() {
  final conditions = [
    [1 << 9, 100000],
    [1 << 15, 10000],
    [1 << 23, 10],
  ];
  print('--------- XXH3 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH3Benchmark(size, iter).measureRate();
  }
  print('--------- XXH32 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH32Benchmark(size, iter).measureRate();
  }
  print('--------- XXH64 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH64Benchmark(size, iter).measureRate();
  }
  print('--------- XXH128 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH128Benchmark(size, iter).measureRate();
  }
}

/*
benchmarking large inputs : from 512 bytes (log9) to 128 MB (log27)
xxh3   , 24798, 30406, 32255, 34043, 34979, 35244, 34881, 35331, 35457, 35569, 35266, 35240, 34807, 35173, 35349, 35438, 31891, 31502, 32324
XXH32  ,  7419,  7542,  7658,  7667,  7884,  7886,  7864,  7836,  7775,  7852,  7862,  7826,  7857,  7870,  7761,  7962,  7777,  7766,  7623
XXH64  , 11935, 12752, 13125, 13216, 13356, 13559, 13573, 13485, 13326, 13615, 13444, 13721, 13250, 13333, 13449, 13464, 13218, 13001, 13036
XXH128 , 20893, 27057, 30375, 32641, 34044, 34518, 34821, 35189, 35489, 35323, 34665, 33807, 33404, 34843, 34691, 33877, 30740, 31530, 30862
---------------------
For a string of size 2^23 (= 8388608) :
xxh3 = 35349 @ 35.35 GB/s
XXH32 = 7761 @ 7.76 GB/s
XXH64 = 13464 @ 13.46 GB/s
XXH128 = 33877 @ 33.88 GB/s
*/

/*
--------- XXH3 ----------
XXH3 : 540.001 ms => #185185 @ 94.81 MB/s 
XXH3 : 3230.378 ms => #3096 @ 101.44 MB/s 
XXH3 : 840.254 ms => #12 @ 99.83 MB/s 
--------- XXH32 ----------
XXH32 : 120.106 ms => #832598 @ 426.29 MB/s 
XXH32 : 614.086 ms => #16284 @ 533.61 MB/s 
XXH32 : 159.395 ms => #63 @ 526.28 MB/s 
--------- XXH64 ----------
XXH64 : 152.619 ms => #655226 @ 335.48 MB/s 
XXH64 : 897.28 ms => #11145 @ 365.19 MB/s 
XXH64 : 236.461 ms => #42 @ 354.76 MB/s 
--------- XXH128 ----------
XXH128 : 805.428 ms => #124158 @ 63.57 MB/s 
XXH128 : 3302.712 ms => #3028 @ 99.22 MB/s 
XXH128 : 854.372 ms => #12 @ 98.18 MB/s 
*/
