@echo OFF
color f2
title ADB
mode con:cols=120 lines=50
:start
cls
ECHO ________________________________________________________________________________________________________________________                                                                                                               
ECHO         .8.          8 888888888o.      8 888888888o      8 8888888888   8 888888888o.   8 8888888888   8 8888888888   
ECHO        .888.         8 8888     `^888.   8 8888    `88.    8 8888         8 8888    `88.  8 8888         8 8888         
ECHO       .88888.        8 8888        `88. 8 8888     `88    8 8888         8 8888     `88  8 8888         8 8888         
ECHO      . `88888.       8 8888         `88 8 8888     ,88    8 8888         8 8888     ,88  8 8888         8 8888         
ECHO     .8. `88888.      8 8888          88 8 8888.   ,88'    8 888888888888 8 8888.   ,88'  8 888888888888 8 888888888888 
ECHO    .8`8. `88888.     8 8888          88 8 8888888888      8 8888         8 888888888P'   8 8888         8 8888         
ECHO   .8' `8. `88888.    8 8888         ,88 8 8888    `88.    8 8888         8 8888`8b       8 8888         8 8888         
ECHO  .8'   `8. `88888.   8 8888        ,88' 8 8888      88    8 8888         8 8888 `8b.     8 8888         8 8888         
ECHO .888888888. `88888.  8 8888    ,o88P'   8 8888    ,88'    8 8888         8 8888   `8b.   8 8888         8 8888         
ECHO.8'       `8. `88888. 8 888888888P'      8 888888888P      8 8888         8 8888     `88. 8 888888888888 8 888888888888 
ECHO ________________________________________________________________________________________________________________________  
ECHO                                             What would you like to do?
ECHO ________________________________________________________________________________________________________________________  
ECHO 1. Factory Reset                               2. Pull Data                                     3. Reboot to ODIN mode
ECHO 4. Reset ADB (use if there are any errors)     5. Mirror phone screen                           6. Exit
ECHO ________________________________________________________________________________________________________________________  
set /p choice=Type the number to select process.
rem if not '%choice%'=='' set choice=%choice:~0;1% ( don`t use this command, because it takes only first digit in the case you type more digits. After that for example choice 23455666 is choice 2 and you get "bye"
if '%choice%'=='' ECHO "%choice%" is not valid please try again
if '%choice%'=='1' goto wipe
if '%choice%'=='2' goto pull
if '%choice%'=='3' goto odin
if '%choice%'=='4' goto killadb
if '%choice%'=='5' goto adbcontrol
if '%choice%'=='6' goto exit
ECHO.
goto start
:wipe
cls
ECHO ________________________________________________________________________________________________________________________  
echo                               Enable USB Debugging and plug device into USB port
adb kill-server
adb wait-for-device reboot recovery
ECHO ________________________________________________________________________________________________________________________  
ECHO                     Using Vol +/- and power navigate to factory reset then confirm process.
pause
goto end
:pull
cls
ECHO ________________________________________________________________________________________________________________________  
echo                                 Enable USB Debugging and plug device into USB port.
echo                            Go to Contacts>settings>import/export and export to local storage.
adb wait-for-device devices
mkdir adbpull
adb pull /storage/sdcard0/ adbpull/
adb backup -noapk -shared -f backup.ab
ECHO ________________________________________________________________________________________________________________________  
ECHO                 Data dump complete. Please unplug Sending device and plug in Recieving device.
pause
adb kill-server
adb wait-for-device devices
adb restore backup.ab
adb push ./adbpull /storage/sdcard0/
del /f .\backup.ab
rd /q /s adbpull
ECHO ________________________________________________________________________________________________________________________  
ECHO                   Don't forget to go back to contacts and IMPORT the contacts to the new phone!
pause
goto end
:killadb
cls
adb kill-server
ECHO                                              ADB server stopped.
pause
goto end
:odin
adb kill-server
adb wait-for-device reboot-bootloader
ECHO                                     Device booting to Download (ODIN) mode
pause
goto end
:adbcontrol
java -jar adbcontrol.jar
goto end
:end
cls
goto start
:exit
exit