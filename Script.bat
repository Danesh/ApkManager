@echo off
setlocal enabledelayedexpansion
COLOR 0A
if (%1)==(0) goto skipme
if (%1) neq () goto adbi
echo -------------------------------------------------------------------------- >> log.txt
echo ^|%date% -- %time%^| >> log.txt
echo -------------------------------------------------------------------------- >> log.txt
echo Script 0 2>> log.txt
:skipme
IF EXIST apkver.txt (del apkver.txt)
IF EXIST %~dp0other\Script.bat (del %~dp0other\Script.bat)
other\wget http://dl.dropbox.com/u/14513610/apkver.txt
cls
IF NOT EXIST apkver.txt (goto :error)
set /a bool = 0
set info = ""
for /f "tokens=*" %%a in (apkver.txt) do (
if !bool!==0 set /a tmpv=%%a
if !bool!==1 set info=!info!%%a
set /a bool = 1
)
del apkver.txt
rem Apk Manager version code
set /a ver = 7
if /I %tmpv% GTR %ver% (
cd other
wget http://dl.dropbox.com/u/14513610/Script.bat
cls
IF EXIST Script.bat (
echo New Update Was Found
echo.
goto changed
:recall
PAUSE
cd ..
Start cmd /c other\signer 3
exit
)
)
:error
cd "%~dp0"
mode con:cols=81 lines=42
mkdir projects
mkdir place-apk-here-for-modding
mkdir place-ogg-here
mkdir place-apk-here-to-batch-optimize
mkdir place-apk-here-for-signing
mkdir projects
cls
set usrc=9
set dec=0
set capp=None
set heapy=64
set jar=0
java -version 
if errorlevel 1 goto errjava
adb version 
if errorlevel 1 goto erradb
set /A count=0
FOR %%F IN (place-apk-here-for-modding/*) DO (
set /A count+=1
set tmpstore=%%~nF%%~xF
)
if %count%==1 (set capp=%tmpstore%)
cls
:restart
if %dec%==0 (set decs=Sources and Resources)
if %dec%==1 (set decs=Sources)
if %dec%==2 (set decs=Resources)
cd "%~dp0"
set menunr=GARBAGE
cls
echo  ------------------------------------------------------------------------------
echo  ^| Compression-Level: %usrc% ^| Heap Size: %heapy%mb ^| Current-App: %capp% ^|
echo  ------------------------------------------------------------------------------
echo  ----------------------------------
echo  Simple Tasks Such As Image Editing
echo  ----------------------------------
echo  0    Adb pull
echo  1    Extract apk
echo  2    Optimize images inside
echo  3    Zip apk 
echo  4    Sign apk (Dont do this if its a system apk)
echo  5    Zipalign apk (Do once apk is created/signed)
echo  6    Install apk (Dont do this if system apk, do adb push)
echo  7    Zip / Sign / Install apk (All in one step)
echo  8    Adb push (Only for system apk)
echo  -------------------------------------------------------------------------------
echo  Advanced Tasks Such As Code Editing ^| Decompile : %decs% 
echo  -------------------------------------------------------------------------------
echo  9    Decompile apk
echo  10   Decompile apk (with dependencies) (For propietary rom apks)
echo  11   Compile apk
echo  12   Sign apk 
echo  13   Install apk
echo  14   Compile apk / Sign apk / Install apk (Non System Apps Only)
echo  -----------
echo  Other Stuff
echo  -----------
echo  15   Batch Optimize Apk (inside place-apk-here-to-batch-optimize only)
echo  16   Sign an apk(Batch support)(inside place-apk-here-for-signing folder only)
echo  17   Batch optimize ogg files (inside place-ogg-here only)
echo  18   Clean Files/Folders
echo  19   Select compression level for apk's
echo  20   Set Max Memory Size (Only use if getting stuck at decompiling/compiling)
echo  21   Read Log
echo  22   Set current project
echo  23   About / Tips / Debug Section
echo  24   Update tools
echo  25   Switch decompile mode
echo  26   Quit
echo  -------------------------------------------------------------------------------
SET /P menunr=Please make your decision:
IF %menunr%==0 (goto ap)
IF %menunr%==15 (goto bopt)
IF %menunr%==16 (goto asi)
IF %menunr%==17 (goto ogg)
IF %menunr%==19 (goto usrcomp)
IF %menunr%==20 (goto heap)
IF %menunr%==21 (goto logr)
IF %menunr%==22 (goto filesel)
IF %menunr%==23 (goto about)
IF %menunr%==24 (goto update)
IF %menunr%==25 (goto switchc)
IF %menunr%==26 (goto quit)
IF %menunr%==18 (goto cleanp)
if %capp%==None goto noproj
IF %menunr%==1 (goto ex)
IF %menunr%==2 (goto opt)
IF %menunr%==3 (goto zip)
IF %menunr%==4 (goto si)
IF %menunr%==5 (goto zipa)
IF %menunr%==6 (goto ins)
IF %menunr%==7 (goto alli)
IF %menunr%==8 (goto apu)
IF %menunr%==9 (goto de)
IF %menunr%==10 (goto ded)
IF %menunr%==11 (goto co)
IF %menunr%==12 (goto si)
IF %menunr%==13 (goto ins)
IF %menunr%==14 (goto all)
:WHAT
echo You went crazy and entered something that wasnt part of the menu options
PAUSE
goto restart
:switchc
set /a dec+=1 
if (%dec%)==(3) (set /a dec=0)
goto restart
:update
cd other
echo 1. Use apktool 1.3.1
echo 2. Update to latest tools
SET /P menunr=Please make your decision:
IF %menunr%==1 (goto oldapktool)
IF %menunr%==2 (goto alltools)
echo You went crazy and entered something that wasnt part of the menu options
PAUSE
goto restart
:alltools
IF EXIST ApkManagerTools.7z del ApkManagerTools.7z
echo Syncing Tools/Script....
IF NOT EXIST ApkManagerTools.7z (
wget http://dl.dropbox.com/u/14513610/ApkManager/ApkManagerTools.7z
)
7za x -y -o"./" "ApkManagerTools.7z"
del ApkManagerTools.7z
goto restart
:oldapktool
wget http://dl.dropbox.com/u/14513610/ApkManager/apktool1.3.1.jar -O apktool.jar
goto restart
:cleanp
echo 1. Clean This Project's Folder
echo 2. Clean All Apk's in Modding Folder
echo 3. Clean All OGG's in OGG Folder
echo 4. Clean All Apk's in Optimize Folder
echo 5. Clean All Apk's in Signing Folder
echo 6. Clean All Projects
echo 7. Clean All Folders/Files
echo 8. Go Back To Main Menu
SET /P menuna=Please make your decision:
echo Clearing Directories
IF %menuna%==1 (
if %capp%==None goto noproj
rmdir /S /Q %userprofile%\apktool > nul
rmdir /S /Q projects\%capp% > nul
mkdir projects\%capp%
)
IF %menuna%==2 (
rmdir /S /Q %userprofile%\apktool > nul
rmdir /S /Q place-apk-here-for-modding > nul
mkdir place-apk-here-for-modding
)
IF %menuna%==3 (
rmdir /S /Q place-ogg-here > nul
mkdir place-ogg-here
)
IF %menuna%==4 (
rmdir /S /Q place-apk-here-to-batch-optimize > nul
mkdir place-apk-here-to-batch-optimize
)
IF %menuna%==5 (
rmdir /S /Q place-apk-here-for-signing > nul
mkdir place-apk-here-for-signing
)
IF %menuna%==7 (
rmdir /S /Q %userprofile%\apktool > nul
rmdir /S /Q projects\%capp% > nul
mkdir projects\%capp%
rmdir /S /Q place-apk-here-for-modding > nul
mkdir place-apk-here-for-modding
rmdir /S /Q place-ogg-here > nul
mkdir place-ogg-here
rmdir /S /Q place-apk-here-to-batch-optimize > nul
mkdir place-apk-here-to-batch-optimize
rmdir /S /Q place-apk-here-for-signing > nul
mkdir place-apk-here-for-signing
rmdir /S /Q %userprofile%\apktool > nul
rmdir /S /Q projects > nul
mkdir projects
)
IF %menuna%==6 (
rmdir /S /Q %userprofile%\apktool > nul
rmdir /S /Q projects > nul
mkdir projects
)
goto restart
:about
cls
echo Version
echo -------
type other\version.txt
echo Tips
echo ----
echo 1. If Modifying system apps, never resign them unless you want to resign all
echo apk's that share its shared:uid
echo 2. If decompiling/recompiling system apps and if AndroidManifest.xml was not
echo preserved from the original apk, then either push the apk when in recovery or
echo by doing :
echo adb remount
echo adb shell stop
echo adb push something.apk /wherever/something.apk
echo adb shell start
echo 3. Decompiling a themed apk is not possible, you must get the original unthemed
echo apk, then decompile, make your theme/xml changes and recompile
echo 4. If you're stuck and the log doesnot give you any indication as to what you 
echo are doing wrong, then post in the thread http://www.tiny.cc/apkmanager
echo Make sure u include ur log.txt, and if its not a editing problem i.e 
echo its something regarding when u push it to your phone, then post ur adb log 
echo as well. To do so 
echo follow these steps :
echo 1. Connect ur phone to ur pc
echo 2. Push/install the app on your phone
echo 3. Select "Create Log" option on this menu
echo 4. Run the app on your phone
echo 5. Let the new window run for 10 seconds, then close it
echo Once done, you will find a adblog.txt in the root folder
echo Upload that as well.
echo.
echo 1. Create log
echo 2. Go back to main menu
SET /P menunr=Please make your decision:
IF %menunr%==1 (Start "Adb Log" other\signer 2)
goto restart
:portapk
echo Im going to try resigning the apk and see if that works
echo Did it successfully install (y/n) ^?
echo Ok, lets try looking through for any shared uid, if i find any i will remove them
:filesel
cls
set /A count=0
FOR %%F IN (place-apk-here-for-modding/*) DO (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 (echo ^- !count!  - %%F )
if /I !count! GTR 10 (echo ^- !count! - %%F )
)
echo.
echo Choose the app to be set as current project?
set /P INPUT=Enter It's Number: %=%
if /I %INPUT% GTR !count! (goto chc)
if /I %INPUT% LSS 1 (goto chc)
set capp=!a%INPUT%!
set jar=0
set ext=jar
IF "!capp:%ext%=!" NEQ "%capp%" set jar=1
goto restart
:chc
set capp=None
goto restart
rem :bins
rem echo Waiting for device
rem adb wait-for-device
rem echo Installing Apks
rem FOR %%F IN ("%~dp0place-apk-here-for-signing\*.apk") DO adb install -r "%%F"
rem goto restart
:heap
set /P INPUT=Enter max size for java heap space in megabytes (eg 512) : %=%
set heapy=%INPUT%
cls
goto restart
:usrcomp
set /P INPUT=Enter Compression Level (0-9) : %=%
set usrc=%INPUT%
cls
goto restart
:ogg
cd other
mkdir temp
echo Optimizing Ogg
FOR %%F IN ("../place-ogg-here/*.ogg") DO sox "../place-ogg-here/%%F" -C 0 "temp\%%F"
cd ..
MOVE other\temp\*  place-ogg-here
rmdir /S /Q other\temp
goto restart
:alli
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cls
echo 1    System apk (Retains signature)
echo 2    Regular apk (Removes signature for re-signing)
SET /P menunr=Please make your decision: 
IF %menunr%==1 (goto sys1)
IF %menunr%==2 (goto oa1)
:sys1
echo Zipping Apk
cd other
7za a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
cd ..
goto si1
:oa1
cd other
echo Zipping Apk
rmdir /S /Q "../out/META-INF"
7za a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
cd ..
:si1
cd other
echo Signing Apk
java -Xmx%heapy%m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../place-apk-here-for-modding/unsigned%capp% ../place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
cd ..
:ins1
echo Waiting for device
adb wait-for-device
echo Installing Apk
adb install -r place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
goto restart
:asi
cd other
DEL /Q "../place-apk-here-for-signing/signed.apk"
FOR %%F in (../place-apk-here-for-signing/*) DO call signer "%%F"
cd ..
goto restart
:bopt
set /P INPUT=Do you want to zipalign(z), optimize png(p) or both(zp)? : %=%
FOR %%F IN (place-apk-here-to-batch-optimize\*.apk) DO (call :dan "%%F")
MOVE "other\optimized\*.apk" "place-apk-here-to-batch-optimize"
rmdir /S /Q "other\optimized"
goto restart
:dan
if (%INPUT%)==(zp) GOTO zipb
if (%INPUT%)==(z) GOTO zipo
:zipb
@echo Optimizing %~1...
cd other
md "apkopt_temp_%~n1"
md optimized
dir /b
7za x -o"apkopt_temp_%~n1" "../place-apk-here-to-batch-optimize/%~n1%~x1"
mkdir temp
xcopy "apkopt_temp_%~n1\res\*.9.png" "temp" /S /Y
roptipng -o99 "apkopt_temp_%~n1\**\*.png"
del /q "..\place-apk-here-to-batch-optimize\%~n1%~x1"
xcopy "temp" "apkopt_temp_%~n1\res" /S /Y
rmdir "temp" /S /Q
if (%INPUT%)==(p) GOTO ponly
7za a -tzip "optimized\%~n1.unaligned.apk" "%~dp0other\apkopt_temp_%~n1\*" -mx%usrc% 
rd /s /q "apkopt_temp_%~n1"
zipalign -v 4 "optimized\%~n1.unaligned.apk" "optimized\%~n1.apk"
del /q "optimized\%~n1.unaligned.apk"
goto endab
:ponly
7za a -tzip "optimized\%~n1.apk" "%~dp0other\apkopt_temp_%~n1\*" -mx%usrc%
rd /s /q "apkopt_temp_%~n1"
goto endab
:zipo
@echo Optimizing %~1...
zipalign -v 4 "%~dp0place-apk-here-to-batch-optimize\%~n1%~x1" "%~dp0place-apk-here-to-batch-optimize\u%~n1%~x1"
del /q "%~dp0place-apk-here-to-batch-optimize\%~n1%~x1"
rename "%~dp0place-apk-here-to-batch-optimize\u%~n1%~x1" "%~n1%~x1"
goto endab
:dirnada
echo %capp% has not been extracted, please do so before doing this step
PAUSE
goto restart
:opt
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
mkdir temp
xcopy "%~dp0projects\%capp%\res\*.9.png" "%~dp0temp" /S /Y
cd other
echo Optimizing Png's
roptipng -o99 "../projects/%capp%/**/*.png"
cd ..
xcopy "%~dp0temp" "%~dp0projects\%capp%\res" /S /Y
rmdir temp /S /Q
goto restart
:noproj
echo Please Select A Project To Work On (Option #22)
PAUSE
goto restart
:ap
echo Where do you want adb to pull the apk from? 
echo Example of input : /system/app/launcher.apk
set /P INPUT=Type input: %=%
echo Pulling apk
adb pull %INPUT% "%~dp0place-apk-here-for-modding\something.apk"
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
goto restart
)
set jar=0
set ext=jar
IF "!INPUT:%ext%=!" NEQ "%INPUT%" set jar=1
:renameagain
echo What filename would you like this app to be stored as ?
echo Eg (launcher.apk)
set /P INPUT=Type input: %=%
IF EXIST "%~dp0place-apk-here-for-modding\%INPUT%" (
echo File Already Exists, Try Another Name
PAUSE
goto renameagain)
rename "%~dp0place-apk-here-for-modding\something.apk" %INPUT%
echo Would you like to set this as your current project (y/n)?
set /P inab=Type input: %=%
if %inab%==y (set capp=%INPUT%)
goto restart
:apu
echo Where do you want adb to push to and as what name 
echo Example of input : /system/app/launcher.apk
set /P INPUT=Type input: %=%
echo Waiting for device
adb wait-for-device
adb remount
echo Pushing apk
adb push "place-apk-here-for-modding\unsigned%capp%" %INPUT%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
goto restart
:zipa
cd other
echo Zipaligning Apk
IF EXIST "%~dp0place-apk-here-for-modding\signed%capp%" zipalign -f 4 "%~dp0place-apk-here-for-modding\signed%capp%" "%~dp0place-apk-here-for-modding\signedaligned%capp%"

IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" zipalign -f 4 "%~dp0place-apk-here-for-modding\unsigned%capp%" "%~dp0place-apk-here-for-modding\unsignedaligned%capp%"

if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
DEL /Q "%~dp0place-apk-here-for-modding\signed%capp%"
DEL /Q "%~dp0place-apk-here-for-modding\unsigned%capp%"
rename "%~dp0place-apk-here-for-modding\signedaligned%capp%" signed%capp%
rename "%~dp0place-apk-here-for-modding\unsignedaligned%capp%" unsigned%capp%
goto restart
:ex
cd other
echo Extracting apk
IF EXIST "../projects/%capp%" (rmdir /S /Q "../projects/%capp%")
7za x -o"../projects/%capp%" "../place-apk-here-for-modding/%capp%"
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
cd ..
goto restart
:zip
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cls
echo 1    System apk (Retains signature)
echo 2    Regular apk (Removes signature for re-signing)
SET /P menunr=Please make your decision: 
IF %menunr%==1 (goto sys)
IF %menunr%==2 (goto oa)
:sys
echo Zipping Apk
cd other
7za a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)

cd ..
goto restart
:oa
cd other
echo Zipping Apk
rmdir /S /Q "../out/META-INF"
7za a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)

cd ..
goto restart
:ded
cd other
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
:temr
echo Drag the dependee apk in this window or type its path
echo Example to decompile Rosie.apk, drag com.htc.resources.apk in this window
set /P INPUT=Type input: %=%
java -jar apktool.jar if %INPUT%
if NOT EXIST %userprofile%\apktool\framework\2.apk (
echo.
echo "Sorry thats not the dependee apk, try again"
goto temr
)
echo Decompiling Apk
java -Xmx%heapy%m -jar apktool.jar d ../place-apk-here-for-modding/%capp% ../projects/%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
cd ..
goto restart
:de
cd other
DEL /Q "../place-apk-here-for-modding/signed%capp%"
DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
IF EXIST "../projects/%capp%" (rmdir /S /Q "../projects/%capp%")
if (%jar%)==(0) (echo Decompiling Apk)
if (%jar%)==(1) (echo Decompiling Jar)
if (%dec%)==(0) (set ta=)
if (%dec%)==(1) (set ta=-r)
if (%dec%)==(2) (set ta=-s)
if (%jar%)==(1) (set ta=-r)
java -Xmx%heapy%m -jar apktool.jar d %ta% "../place-apk-here-for-modding/%capp%" "../projects/%capp%"
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
cd ..
goto restart
:co
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cd other
if (%jar%)==(0) (echo Building Apk)
if (%jar%)==(1) (echo Building Jar)
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
java -Xmx%heapy%m -jar apktool.jar b "../projects/%capp%" "%~dp0place-apk-here-for-modding\unsigned%capp%"
if (%jar%)==(0) (goto :nojar)
7za x -o"../projects/temp" "../place-apk-here-for-modding/%capp%" META-INF -r
7za a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../projects/temp/*" -mx%usrc% -r
rmdir /S /Q "%~dp0projects/temp"
goto restart
:nojar
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
goto restart
)
echo Is this a system apk ^(y/n^)
set /P INPU=Type input: %=%
if %INPU%==n (goto q1)
:nq1
echo Aside from the signatures, would you like to copy
echo over any additional files that you didn't modify
echo from the original apk in order to ensure least 
echo # of errors ^(y/n^)
set /P INPUT1=Type input: %=%
if %INPUT1%==y (call :nq2)
if %INPUT1%==n (call :nq3)
:nq2
rmdir /S /Q "%~dp0keep"
7za x -o"../keep" "../place-apk-here-for-modding/%capp%"
echo In the apk manager folder u'll find
echo a keep folder. Within it, delete 
echo everything you have modified and leave
echo files that you haven't. If you have modified
echo any xml, then delete resources.arsc from that 
echo folder as well. Once done then press enter 
echo on this script.
PAUSE
7za a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../keep/*" -mx%usrc% -r
rmdir /S /Q "%~dp0keep"
cd ..
goto restart
:nq3
7za x -o"../projects/temp" "../place-apk-here-for-modding/%capp%" META-INF -r
7za a -tzip "../place-apk-here-for-modding/unsigned%capp%" "../projects/temp/*" -mx%usrc% -r
rmdir /S /Q "%~dp0projects/temp"
goto restart
:q1
echo Would you like to copy over any additional files 
echo that you didn't modify from the original apk in order to ensure least 
echo # of errors ^(y/n^)
set /P INPU=Type input: %=%
if %INPU%==y (goto nq2)
cd ..
goto restart
:si
cd other
echo Signing Apk
java -Xmx%heapy%m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../place-apk-here-for-modding/unsigned%capp% ../place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)

DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
cd ..
goto restart
:ins
echo Waiting for device
adb wait-for-device
echo Installing Apk
adb install -r place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
goto restart
:all
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cd other
echo Building Apk
IF EXIST "%~dp0place-apk-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-apk-here-for-modding\unsigned%capp%")
java -Xmx%heapy%m -jar apktool.jar b "../projects/%capp%" "%~dp0place-apk-here-for-modding\unsigned%capp%"
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
goto restart
)
echo Signing Apk
java -Xmx%heapy%m -jar signapk.jar -w testkey.x509.pem testkey.pk8 ../place-apk-here-for-modding/unsigned%capp% ../place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
DEL /Q "../place-apk-here-for-modding/unsigned%capp%"
cd ..
echo Waiting for device
adb wait-for-device
echo Installing Apk
adb install -r place-apk-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured, Please Check The Log (option 21)"
PAUSE
)
goto restart
:errjava
cls
echo Java was not found, you will not be able to sign apks or use apktool
PAUSE
goto restart
:erradb
cls
echo Adb was not found, you will not be able to manipulate the files on your phone
PAUSE
goto restart
:adbi
mode con:cols=48 lines=8
echo Waiting for device
adb wait-for-device
set count=0
:loop
if "%~n1"=="" goto :endloop
echo Installing %~n1
adb install -r %1
shift
set /a count+=1
goto :loop
:endloop
goto quit
:changed
echo The Following Was Updated : 
echo.
set /a cc = 1
:recursive
for /f "tokens=%cc% delims=\" %%b in ('echo %info%') do (
echo %%b
set /a cc = %cc% + 1
goto recursive
)
echo.
goto recall
:logr
cd other
Start "Read The Log - Main script is still running, close this to return" signer 1
goto restart
:endab
cd ..
@echo Optimization complete for %~1
:quit