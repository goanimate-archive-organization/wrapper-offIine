:: opens vfproxy in a standalone batch so that i can use a tool that silently runs batch files
:: this is stupid
:: please help
@echo off
pushd "%~dp0"
title VFProxy PHP Launcher for Wrapper: Offline
pushd ..\wrapper\vfproxy
echo Starting PHP server for VFProxy...
echo:
call ..\..\utilities\php\php.exe -S localhost:8181
echo:
exit
