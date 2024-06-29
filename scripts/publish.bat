@echo off
call %~dp0\prepublish.bat
call dart pub publish
