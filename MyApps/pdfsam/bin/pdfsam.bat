@REM This file is part of the PDF Split And Merge source code
@REM Copyright 2014 by Andrea Vacondio (andrea.vacondio@gmail.com).
@REM
@REM This program is free software: you can redistribute it and/or modify
@REM it under the terms of the GNU Affero General Public License as
@REM published by the Free Software Foundation, either version 3 of the
@REM License, or (at your option) any later version.
@REM
@REM This program is distributed in the hope that it will be useful,
@REM but WITHOUT ANY WARRANTY; without even the implied warranty of
@REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@REM GNU General Public License for more details.
@REM
@REM You should have received a copy of the GNU Affero General Public License
@REM along with this program.  If not, see <http://www.gnu.org/licenses/>.

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup
set REPO=


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\lib

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\commons-lang3-3.1.jar;"%REPO%"\eventstudio-1.0.5.jar;"%REPO%"\pdfsam-gui-3.0.0.M1.jar;"%REPO%"\commons-io-2.4.jar;"%REPO%"\sejda-model-1.0.0.RELEASE-SNAPSHOT.jar;"%REPO%"\validation-api-1.0.0.GA.jar;"%REPO%"\pdfsam-i18n-3.0.0.M1.jar;"%REPO%"\gettext-commons-0.9.8.jar;"%REPO%"\pdfsam-core-3.0.0.M1.jar;"%REPO%"\sejda-conversion-1.0.0.RELEASE-SNAPSHOT.jar;"%REPO%"\pdfsam-fx-3.0.0.M1.jar;"%REPO%"\pdfsam-service-3.0.0.M1.jar;"%REPO%"\sejda-core-1.0.0.RELEASE-SNAPSHOT.jar;"%REPO%"\sejda-itext5-1.0.0.RELEASE-SNAPSHOT.jar;"%REPO%"\itextpdf-5.5.3.jar;"%REPO%"\bcprov-jdk15on-1.49.jar;"%REPO%"\bcpkix-jdk15on-1.49.jar;"%REPO%"\hibernate-validator-4.2.0.Final.jar;"%REPO%"\jackson-jr-objects-2.4.1.jar;"%REPO%"\jackson-core-2.4.1.jar;"%REPO%"\javax.inject-1.jar;"%REPO%"\spring-context-4.1.3.RELEASE.jar;"%REPO%"\spring-aop-4.1.3.RELEASE.jar;"%REPO%"\aopalliance-1.0.jar;"%REPO%"\spring-beans-4.1.3.RELEASE.jar;"%REPO%"\spring-core-4.1.3.RELEASE.jar;"%REPO%"\commons-logging-1.2.jar;"%REPO%"\spring-expression-4.1.3.RELEASE.jar;"%REPO%"\fontawesomefx-8.0.10.jar;"%REPO%"\pdfsam-merge-3.0.0.M1.jar;"%REPO%"\pdfsam-simple-split-3.0.0.M1.jar;"%REPO%"\pdfsam-split-by-size-3.0.0.M1.jar;"%REPO%"\pdfsam-split-by-bookmarks-3.0.0.M1.jar;"%REPO%"\pdfsam-alternate-mix-3.0.0.M1.jar;"%REPO%"\pdfsam-rotate-3.0.0.M1.jar;"%REPO%"\jcl-over-slf4j-1.7.7.jar;"%REPO%"\logback-classic-1.1.2.jar;"%REPO%"\logback-core-1.1.2.jar;"%REPO%"\slf4j-api-1.7.7.jar;"%REPO%"\pdfsam-community-3.0.0.M1.jar

set ENDORSED_DIR=
if NOT "%ENDORSED_DIR%" == "" set CLASSPATH="%BASEDIR%"\%ENDORSED_DIR%\*;%CLASSPATH%

if NOT "%CLASSPATH_PREFIX%" == "" set CLASSPATH=%CLASSPATH_PREFIX%;%CLASSPATH%

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% -Xmx256M -classpath %CLASSPATH% -Dapp.name="pdfsam" -Dapp.repo="%REPO%" -Dapp.home="%BASEDIR%" -Dbasedir="%BASEDIR%" org.pdfsam.community.App %CMD_LINE_ARGS%
if %ERRORLEVEL% NEQ 0 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=%ERRORLEVEL%

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@REM If error code is set to 1 then the endlocal was done already in :error.
if %ERROR_CODE% EQU 0 @endlocal


:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
