:: Wrapper: Offline "Configure" window
:: Original Author: TheJuboy2009#8434
:: Modified by: xomdjl_#1337 (ytpmaker1000@gmail.com)
@echo off
title Wrapper: Offline debug/experimental CMD window
echo Type a Wrapper command, it can be anything like: "npm install" or "npm install http-server -g"
echo:
echo This window is useful for debugging and for figuring out any problems with any of the included
echo software.
echo:
echo Additionally, you could use this window to experiment with integrating new CLI tools in your copy
echo of Wrapper: Offline.
echo:
echo Regardless if either your software crashes or you use 0 to close Wrapper, this CMD window will NOT
echo close unless you force this this window to close.
echo:
call cmd /k