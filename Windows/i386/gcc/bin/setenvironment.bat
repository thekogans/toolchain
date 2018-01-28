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

set TOOLCHAIN_MINGW_DIR=%1

call %1\mingw.bat
