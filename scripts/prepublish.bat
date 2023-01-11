@echo off
call dart format --fix .
call dart analyze 
call dart test
call dart doc
