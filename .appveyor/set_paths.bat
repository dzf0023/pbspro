@echo off
REM Copyright (C) 1994-2017 Altair Engineering, Inc.
REM For more information, contact Altair at www.altair.com.
REM
REM This file is part of the PBS Professional ("PBS Pro") software.
REM
REM Open Source License Information:
REM
REM PBS Pro is free software. You can redistribute it and/or modify it under the
REM terms of the GNU Affero General Public License as published by the Free
REM Software Foundation, either version 3 of the License, or (at your option) any
REM later version.
REM
REM PBS Pro is distributed in the hope that it will be useful, but WITHOUT ANY
REM WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
REM PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.
REM
REM You should have received a copy of the GNU Affero General Public License along
REM with this program.  If not, see <http://www.gnu.org/licenses/>.
REM
REM Commercial License Information:
REM
REM The PBS Pro software is licensed under the terms of the GNU Affero General
REM Public License agreement ("AGPL"), except where a separate commercial license
REM agreement for PBS Pro version 14 or later has been executed in writing with Altair.
REM
REM Altair’s dual-license business model allows companies, individuals, and
REM organizations to create proprietary derivative works of PBS Pro and distribute
REM them - whether embedded or bundled with other software - under a commercial
REM license agreement.
REM
REM Use of Altair’s trademarks, including but not limited to "PBS™",
REM "PBS Professional®", and "PBS Pro™" and Altair’s logos is subject to Altair's
REM trademark licensing policies.

@echo off
set __OLD_DIR="%CD%"
cd "%~dp0..\.."

REM SVN is used by Python internally, to download it's dependencies
if not defined SVN_BIN (
    set SVN_BIN=svn
)
if not defined CURL_BIN (
    set CURL_BIN=curl
)
if not defined UNZIP_BIN (
    set UNZIP_BIN=unzip
)
if not defined MSYSDIR (
    set MSYSDIR=C:\MinGW\msys\1.0
)
if not defined PERL_BIN (
    set PERL_BIN=perl
)
if not defined CMAKE_BIN (
    set CMAKE_BIN=cmake
)
if not defined __BINARIESDIR (
    set __BINARIESDIR=%CD%\binaries
)
if exist "%VS90COMNTOOLS%vsvars32.bat" (
    call "%VS90COMNTOOLS%vsvars32.bat"
) else (
    echo "Could not find %VS90COMNTOOLS%vsvars32.bat"
    exit 1
)

set __RANDOM_VAL=%RANDOM::=_%
set __RANDOM_VAL-%RANDOM_VAL:.=%
set __BINARIESJUNCTION=%__BINARIESDIR:~0,2%\__withoutspace_binariesdir_%__RANDOM_VAL%
if not exist "%__BINARIESDIR%" (
    mkdir "%__BINARIESDIR%"
)
if not "%__BINARIESDIR: =%"=="%__BINARIESDIR%" (
    mklink /J %__BINARIESJUNCTION% "%__BINARIESDIR%"
    if not %ERRORLEVEL% == 0 (
        echo "Could not create junction to %__BINARIESJUNCTION% to %__BINARIESDIR% which contains space"
        exit 1
    )
    cd %__BINARIESJUNCTION%
) else (
    cd %__BINARIESDIR%
)
set BINARIESDIR=%CD%
for /F "usebackq tokens=*" %%i in (`""%MSYSDIR%\bin\bash.exe" -c "pwd""`) do set BINARIESDIR_M=%%i

if not defined LIBEDIT_VERSION (
    set LIBEDIT_VERSION=2.204
)
if not defined LIBICAL_VERSION (
    set LIBICAL_VERSION=1.0.1
)
if not defined PGSQL_VERSION (
    set PGSQL_VERSION=9.6.3
)
if not defined PYTHON_VERSION (
    set PYTHON_VERSION=2.7.13
)
if not defined OPENSSL_VERSION (
    set OPENSSL_VERSION=1_1_0f
)
if not defined SWIG_VERSION (
    set SWIG_VERSION=3.0.12
)
if not defined TCL_VERSION (
    set TCL_VERSION=8.6.6
)
if not defined TK_VERSION (
    set TK_VERSION=8.6.6
)

set DO_DEBUG_BUILD=0
if "%~1"=="debug" (
    set DO_DEBUG_BUILD=1
)
if "%~1"=="Debug" (
    set DO_DEBUG_BUILD=1
)

cd %__OLD_DIR%
