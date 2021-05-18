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
echo Regardless if your software crashes or not, this CMD window will NOT close unless you either force
echo this window to close or start_wrapper.bat closes this window.
echo:
call cmd /k