@echo off

set LANG=en_US.UTF-8
set path=tools\Ruby\bin;%path%

"tools\Ruby\bin\bundle.bat" exec piston %*