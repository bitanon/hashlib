@echo off

rd /s /q "doc" 2>nul
rd /s /q "build" 2>nul

call dart format . || goto :error
call dart analyze --fatal-infos || goto :error
call dart doc --validate-links || goto :error
call dart test || goto :error
call pana --exit-code-threshold 0 || goto :error
goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
