@echo off

rem Copyright 2011 Boris Kogan (boris@thekogans.net)
rem
rem This file is part of thekogans_toolchain.
rem
rem thekogans_toolchain is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem (at your option) any later version.
rem
rem thekogans_toolchain is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
rem GNU General Public License for more details.
rem
rem You should have received a copy of the GNU General Public License
rem along with thekogans_toolchain. If not, see <http://www.gnu.org/licenses/>.

@echo Setting environment for using thekogans.net development toolchain.

if "%1" == "" (
    goto usage
)

if "%2" == "" (
    goto usage
)

if "%3" == "" (
    goto usage
)

if "%4" == "" (
    goto usage
)

if "%5" == "" (
    goto usage
)

cd %~dp0..\..\..
set DEVELOPMENT_ROOT=%CD%

cd %~dp0..\..
for %%A in ("%CD%") do (
    set TOOLCHAIN_NAME=%%~nxA
)
set TOOLCHAIN_ROOT=%DEVELOPMENT_ROOT%\%TOOLCHAIN_NAME%
set TOOLCHAIN_OS=%1
set TOOLCHAIN_ARCH=%2
set TOOLCHAIN_COMPILER=%3
set TOOLCHAIN_ENDIAN=Little
set TOOLCHAIN_BRANCH=%TOOLCHAIN_OS%\%TOOLCHAIN_ARCH%\%TOOLCHAIN_COMPILER%
set TOOLCHAIN_DIR=%TOOLCHAIN_ROOT%\%TOOLCHAIN_BRANCH%
if not exist %TOOLCHAIN_DIR% (
    echo toolchain %TOOLCHAIN_DIR% does not exist.
    goto done
)
set TOOLCHAIN_TRIPLET=%TOOLCHAIN_OS%-%TOOLCHAIN_ARCH%-%TOOLCHAIN_COMPILER%

set TOOLCHAIN_VISUAL_STUDIO_BRANCH=%4
if not %TOOLCHAIN_VISUAL_STUDIO_BRANCH% == "" (
    @set "TOOLCHAIN_VISUAL_STUDIO_DIR=%VCINSTALLDIR%bin\%TOOLCHAIN_VISUAL_STUDIO_BRANCH%"
) else (
    @set "TOOLCHAIN_VISUAL_STUDIO_DIR=%VCINSTALLDIR%bin"
)

set TOOLCHAIN_WINDOWS_SDK_BRANCH=%5
if not %TOOLCHAIN_WINDOWS_SDK_BRANCH% == "" (
    @set "TOOLCHAIN_WINDOWS_SDK_DIR=%WindowsSdkDir%Bin\%TOOLCHAIN_WINDOWS_SDK_BRANCH%"
) else (
    @set "TOOLCHAIN_WINDOWS_SDK_DIR=%WindowsSdkDir%Bin"
)

if %TOOLCHAIN_ARCH% == "i386" (
    @set "TOOLCHAIN_MASM=ml.exe"
) else (
    @set "TOOLCHAIN_MASM=ml64.exe"
)

set TOOLCHAIN_CYGWIN_MOUNT_TABLE=%TOOLCHAIN_ROOT%\common\resources\cygwin_mount_table.txt
mount > %TOOLCHAIN_CYGWIN_MOUNT_TABLE%

set PATH=%TOOLCHAIN_DIR%\bin;%TOOLCHAIN_ROOT%\common\bin;%PATH%

goto done

:usage

echo usage: setenvironment.bat os arch compiler visual_studio_branch windows_sdk_branch
echo os = Windows
echo arch = [i386 ^| x86_64 ^| ...]
echo compiler = [cl16 ^| cl18 ^| ...]
echo visual_studio_branch = [amd64 ^| x86_amd64 ^| ...]
echo windows_sdk_branch = [x64 ^| ...]

:done
