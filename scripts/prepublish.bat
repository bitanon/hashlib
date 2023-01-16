@echo off
call dart format --fix .
call dart analyze --fatal-infos
call dart test
call dart doc
