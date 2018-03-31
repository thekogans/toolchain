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

rem This script prepares a cygwin bash shell to be used with thekogans.net
rem development environment and build system using Visual Studio as the compiler.

rem Use this line in mintty.exe Properties dialog box. You'll need to
rem provide paths where you installed the toolchain and Visual Studio.
rem The -p and -s arguments position mintty window. You'll need to
rem provide suitable values for X, Y, WIDTH and HEIGHT or take them
rem out all together and let the system position and size the window.

rem 'path to cygwin bin'\mintty.exe -i /Cygwin-Terminal.ico -p X,Y -s WIDTH,HEIGHT \
rem -e %comspec% /k 'path to toolchain root'\Windows\setenvironment.bat \
rem "path to vcvarsall.bat" [x86 | amd64 | ...] [i386 | x86_64 | ...] [cl18 | cl19 | cl1910 | ...]

rem Perform basic sanity checks.
if Not Exist ""%1"" (
    echo %1 not found.
    goto usage
)
if "%2" == "" (
    echo Must provide an architecture parameter to configure Visual Studio.
    goto usage
)

rem Let Visual Studio setup it's comand line build environment.
call %1 %2

rem Specify thekogans.net toolchain triplet.
set TOOLCHAIN_OS=Windows
set TOOLCHAIN_ARCH=%3
set TOOLCHAIN_COMPILER=%4

rem Finally, run bash on top of the newly created environment.
bash --login

goto done

:usage

echo usage: %0 "Path to vcvarsall.bat" [x86 | amd64 | ...] [i386 | x86_64 | ...] [cl18 | cl19 | cl1910 | ...]

:done
