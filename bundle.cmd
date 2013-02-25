@echo off
setlocal

set LANG=en_US.UTF-8
set PATH=%~dp0tools\Ruby\bin;%~dp0tools\Git\bin;%path%
set RUBY=tools\Ruby\bin\ruby.exe

%RUBY% "tools\Ruby\bin\bundle" %*
exit /b %errorlevel%
