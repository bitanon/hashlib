@echo off
call dart test
call dart run .\benchmark\benchmark.dart > BENCHMARK.md
