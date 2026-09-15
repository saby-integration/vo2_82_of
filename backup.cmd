@echo off
:: Переменные для бэкапа
For /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a.%%b)
 
set year=%date:~6,4%
set month=%date:~3,2%
set day=%date:~0,2%
set date_time_folder=%year%.%month%.%day% %mytime%
set bin_folder=bin
set back_folder=back_build
set curr_path=%CD%
set bin_path=%curr_path%\%bin_folder%
set back_path=%bin_path%\%back_folder%

:: Перейти в бинарники
mkdir %bin_folder%\%back_folder%\"%date_time_folder%" 

xcopy "%bin_path%\Sbis1C.epf" "%back_path%\%date_time_folder%\" /y

cd "%curr_path%"