@echo off
@title   OCTAV - Simphony problem solver assistant
setlocal EnableDelayedExpansion
FOR /F "delims=: tokens=2" %%a in ('ipconfig ^| find "IPv4"') do set _IPAddress=%%a
SET sqlpath=C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\
SET SQLLOG=C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\Log
color 0C


:menu_start
cls
echo				OS USER : %username%      %date%      IP  : %_IPAddress%
echo 					Created by : by Alexandru Creita and Madalin Frangu 
echo								Version : 1.0                                      
echo							Simphony Team Bucharest                
echo							   Oracle Hospitality                
echo.                                                       
echo				  	      THIS SCRIPT CAN BE USED ONLY BY EXPERIENCED ENGINEERS
echo.
echo								Options
echo          		 -----------------------------------------------------------------
echo.
echo						1 - Restart Micros CAL Service
echo.
echo						2 - Restart SQL Service
echo.
echo						3 - Database Tools
echo.
echo						4 - Workstations issues
echo.
echo						5 - Windows tools
echo.
echo						6 - Workstation tools
echo          		 -----------------------------------------------------------------
echo.

:menu
set /p option=Select 1 or 2 or 3 or 4 or 5 or 6?  
echo.
if '%option%'=='1' goto RestartCAL
if '%option%'=='2' goto RestartSQL
if '%option%'=='3' goto DatabaseTools
if '%option%'=='4' goto WorkstationIssues
if '%option%'=='5' goto Windowstools
if '%option%'=='6' goto WorkstationTools

echo.
echo.
:RestartCAL
echo Restarting Micros CAL Service
net stop "Micros CAL Client"
net start "Micros CAL Client"
echo.
echo.
echo Micros CAL Service was restarted.
pause
goto menu_start

:RestartSQL
echo Restarting SQLExpress Service
net stop mssql$sqlexpress
net start mssql$sqlexpress
echo SQL Express Service was restarted.
pause
goto menu_start

:DatabaseTools
echo.
echo.
echo				DatabaseTools
echo.
echo           -----------------------------------------------------------------
echo 		Please note that all options with (Admin) will require
echo			Servicehost and SQL restart.
echo			Once runned, there will be a workstation downtime
echo.
echo			1 - Admin login SQL
echo.
echo			2 - Backup, drop and create DataStore(Admin)
echo.
echo			3 - Backup, drop and create CheckPostingDB(Admin)
echo.
echo			4 - Backup, drop and create KDSDataStore(Admin)
echo.
echo			5 - Update CAPS Statistics(Admin)
echo.
echo			6 - Update DataStore Statistics(Admin)
echo.
echo			7 - Space used in DataStore(Admin)
echo.
echo			8 - Space used in CAPS(Admin)
echo.
echo			9 - Mrequests status(Admin)
echo.
echo		       10 - Checks with mrequests status 3 only(Admin)
echo.
echo		       11 - Force close checks
echo.
echo		       12 - Back to Main Menu
echo.
echo           -----------------------------------------------------------------
echo.
:menudbtools
set /p optiondb=Select 1 or 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9 or 10 or 11?  
echo.
if '%optiondb%'=='1' goto sqlgodmode
if '%optiondb%'=='2' goto datastorebdc
if '%optiondb%'=='3' goto capsbdc
if '%optiondb%'=='4' goto kdsdatastorebdc
if '%optiondb%'=='5' goto updateCAPSstatistics
if '%optiondb%'=='6' goto updateDatastoreStatistics
if '%optiondb%'=='7' goto spaceusedDatastore
if '%optiondb%'=='8' goto spaceusedCAPS
if '%optiondb%'=='9' goto mrequests
if '%optiondb%'=='10' goto menuviewmrequestsSTS3
if '%optiondb%'=='11' goto closechecks
if '%optiondb%'=='12' goto back



:sqlgodmode
net stop mssql$sqlexpress
net start mssql$sqlexpress /m
echo You are now logged in as Administrator to SQL Express.
SQLCMD -S .\SQLExpress
net stop mssql$sqlexpress
net start mssql$sqlexpress
goto menu_start



:datastorebdc
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "backup database DataStore to disk ='C:\Micros\DataStoreDB.bak'; drop database datastore; create database DataStore;" -o datastore_operation.log
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
echo Backup, Drop and recreation of datastore has been performed (C:\Micros\DataStoreDB.bak), please review datastore_operation.log, if any errors are present.
pause
goto menu_start


:capsbdc
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "backup database CheckPostingDB to disk ='C:\Micros\CAPSDB.bak'; drop database CheckPostingDB; create database CheckPostingDB;" -o CheckPostingDB_operation.log
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
echo Backup, Drop and recreation of CAPSDB has been performed (C:\Micros\CAPSDB.bak), please review CheckPostingDB_operation.log, if any errors are present.
pause
goto menu_start


:kdsdatastorebdc
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "backup database KDSDataStore to disk ='C:\Micros\KDSDataStore.bak'; drop database KDSDataStore; create database KDSDataStore;" -o KDSDataStore_operation.log
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
echo Backup, Drop and recreation of KDSDataStore has been performed (C:\Micros\KDSDataStore.bak), please review KDSDataStore_operation.log, if any errors are present.
pause
goto menu_start


:updateCAPSstatistics
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "update CheckPostingDB.dbo.GLOBAL_PARAMETER set DateVal = getdate() where paramcode = 'LAST_WS_DB_UPDATE_TIME'; " -o CheckPostingDB_operation.log
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
echo CAPS statistics are now up to date.
pause
goto menu_start

:updateDatastoreStatistics
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "update DataStore.dbo.GLOBAL_PARAMETER set DateVal = getdate() where paramcode = 'LAST_WS_DB_UPDATE_TIME'; " -o CheckPostingDB_operation.log
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
echo CAPS statistics are now up to date.
pause
goto menu_start

:spaceusedDatastore
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "sp_spaceused;" -d datastore
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
pause
goto menu_start


:spaceusedCAPS
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "sp_spaceused;" -d checkpostingdb
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
pause
goto menu_start
:back
goto menu_start


:menuviewmrequestsSTS3
echo.
echo 		Select the database
echo           -----------------------------------------------------------------
echo.
echo		1 - CAPS
echo.
echo		2 - DataStore
echo.
echo           -----------------------------------------------------------------
echo.


:menuMrequestsSts3
set /p optiondbs=Select 1 or 2?  
echo.
if '%optiondbs%'=='1' goto viewChecksSTS3CAPS
if '%optiondbs%'=='2' goto viewChecksSTS3Datastore
echo.
echo.


:viewChecksSTS3Datastore
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "use checkpostingdb; select checks.checkid, checks.checknumber, checks.checkopen, checks.checkclose, checks.subtotal, mrequests.reqstate from Checks checks inner join Mrequest_data mrequest_data on checks.checkid = mrequest_data.checkid inner join MRequests mrequests on mrequest_data.rid = mrequests.rid and reqstate = 3; " 
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS 
pause
goto menu_start

:viewChecksSTS3CAPS
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "use checkpostingdb; select checks.checkid, checks.checknumber, checks.checkopen, checks.checkclose, checks.subtotal, mrequests.reqstate from Checks checks inner join Mrequest_data mrequest_data on checks.checkid = mrequest_data.checkid inner join MRequests mrequests on mrequest_data.rid = mrequests.rid and reqstate = 3; " 
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS 
pause
goto menu_start


:mrequests
echo.
echo 		Select the database
echo           -----------------------------------------------------------------
echo.
echo		1 - CAPS
echo		2 - DataStore
echo.
echo           -----------------------------------------------------------------
echo.

:menuMrequests

set /p optionm=Select 1 or 2?  
echo.
if '%optionm%'=='1' goto mrequestsCAPS
if '%optionm%'=='2' goto mrequestsDataStore
echo.
echo.


:mrequestsCAPS

net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "use checkpostingdb;select CONVERT (date ,ReqTime) BusinessDate, case when MREQUESTS.ReqState='0' then 'Pending to Post' when MREQUESTS.ReqState='1' then 'Posted' when MREQUESTS.ReqState='2' then 'Failed Retry Later' when MREQUESTS.ReqState='3' then 'Failed Rejected' end as Enterprise_Posting_Status, ReqState,count (reqstate) as Mrequest_Count from dbo.MREQUESTS group by ReqState,CONVERT (date ,ReqTime) order by CONVERT (date ,ReqTime),ReqState;"
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
pause
goto menu_start


:mrequestsDataStore

net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "use datastore;select CONVERT (date ,ReqTime) BusinessDate, case when MREQUESTS.ReqState='0' then 'Pending to Post' when MREQUESTS.ReqState='1' then 'Posted' when MREQUESTS.ReqState='2' then 'Failed Retry Later' when MREQUESTS.ReqState='3' then 'Failed Rejected' end as Enterprise_Posting_Status, ReqState,count (reqstate) as Mrequest_Count from dbo.MREQUESTS group by ReqState,CONVERT (date ,ReqTime) order by CONVERT (date ,ReqTime),ReqState;"
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
pause
goto menu_start


:WorkstationIssues

echo.
echo 		Workstation Issues
echo.
echo           -----------------------------------------------------------------
echo.
echo		1 - Hexadecimal value 
echo.
echo		2 - Add web.config reload database lines
echo.
echo		3 - Remove from web.config reload database lines
echo.
echo		4 - Recreate secdata.bin and authenticate
echo.
echo		5 - Synch Anchors and DBSettings update
echo.
echo		6 - Extension application not found: Opera
echo.
echo		7 - Back
echo.
echo           -----------------------------------------------------------------
echo.

:menuworkstationissues
set /p optionmenu=Select 1 or 2 or 3 or 4 or 5 or 6 or 7?  
echo.
if '%optionmenu%'=='1' goto hexadecimal
if '%optionmenu%'=='2' goto addwebconfig
if '%optionmenu%'=='3' goto removewebconfig
if '%optionmenu%'=='4' goto authenticate
if '%optionmenu%'=='5' goto synchanchors
if '%optionmenu%'=='6' goto extappOpera
if '%optionmenu%'=='7' goto back

echo.
echo.

pause
:hexadecimal
ECHO Closing Simphony...
taskkill /im ServiceHost.exe /t /f
ECHO Creating backup directory...
set bckpdir=C:\Micros\Simphony\Webserver\wwwroot\Egateway\Handlers\Config files backup %date:~-10,2%-%date:~-7,2%-%date:~-4,4% %time:~0,2%.%time:~3,2%.%time:~6,2%
md "%bckpdir%"
ECHO Moving old files to backup directory -> %bckpdir%
forfiles /s /p C:\MICROS\Simphony\WebServer\wwwroot\EGateway\Handlers\ /m Micros.Payment.DLL.config  /c "cmd /c move @path 0x22%bckpdir%0x22"
forfiles /s /p C:\MICROS\Simphony\WebServer\wwwroot\EGateway\Handlers\ /m Micros.Payment.Cash.dll.config  /c "cmd /c move @path 0x22%bckpdir%0x22"
pause
REM Echo Starting Simphony...
REM C:\Micros\Simphony\WebServer\ServiceHost.exe
goto menu_start

:addwebconfig


::TOREVIEW
::#############################################################################
set /p option=1 for add keys, 2 for remove keys
if '%option%'=='1' goto add
if '%option%'=='2' goto remove
:add
@echo off
set /A totallines=0
for /f %%j in (C:\Micros\Simphony\WebServer\wwwroot\EGateway\web.config.txt) do (set /A totallines+=1)
echo Total lines: %totallines%
SET origfile="C:\Micros\Simphony\WebServer\wwwroot\EGateway\web.config.txt"
cd C:\Micros\Simphony\WebServer\wwwroot\EGateway\
SET tempfile="C:\Micros\Simphony\WebServer\wwwroot\EGateway\web.config.txt.temp"
  SETLOCAL EnableDelayedExpansion
SET /A insertbefore=%totallines%-1
echo Insert before: %insertbefore%
<%origfile% (FOR /L %%i IN (1,1,%totallines%) DO (
  SETLOCAL EnableDelayedExpansion
  SET /P L=
  IF %%i==%insertbefore% ECHO(^<add key="OpsDbDownloadOnStartup" value="true" /^>^<add key="FullDBDownloadonStartUp" value="true" /^>
  ECHO(!L!
  ENDLOCAL
)
) > %tempfile%
timeout 1 > nul
rename web.config.txt web.config.txt.old
rename %tempfile% web.config.txt
goto end
:remove
cd C:\Micros\Simphony\WebServer\wwwroot\EGateway\
rename web.config.txt web.config.txt.temp
rename web.config.txt.old web.config.txt
:end
echo finished
goto menu_start
::#############################################################################
:removewebconfig
cd C:\Micros\Simphony\WebServer\wwwroot\EGateway\
rename web.config.txt web.config.txt.temp
rename web.config.txt.old web.config.txt


:authenticate
echo This feature is not implemented yet, will be done soon.
goto menu_start

:synchanchors
ECHO Note, this procedure will enable the datastoredb SQL user and set a temporary password [datastoredb], once Simphony is started, it will fetch the database credentials set as in EMC.
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
sqlcmd -S localhost\SQLEXPRESS -Q "alter login datastoredb enable; alter login datastoredb with password = 'datastoredb';"
copy NUL DbSettings.xml
echo ^<root^> >> DbSettings.xml
echo ^<db alias="LocalDb" dbType="sqlserver" dataSource="localhost\SQLEXPRESS" catalog="DataStore" uid="datastoredb" pwd="datastoredb" replaceviews="TRUE" /^> >> DbSettings.xml
echo ^<db alias="CPServiceDb" dbType="sqlserver" dataSource="localhost\SQLEXPRESS" catalog="CheckPostingDB" uid="datastoredb" pwd="datastoredb" replaceviews="TRUE" /^> >> DbSettings.xml
echo ^<db alias="CPServiceDb" dbType="sqlserver" dataSource="localhost\SQLEXPRESS" catalog="DataStore" uid="datastoredb" pwd="datastoredb" replaceviews="TRUE" /^> >> DbSettings.xml
echo ^<db alias="KdsServiceDb" dbType="sqlserver" dataSource="localhost\SQLEXPRESS" catalog="KdsDataStore" uid="datastoredb" pwd="datastoredb" replaceviews="TRUE" /^> >> DbSettings.xml
echo ^<db alias="DCALService" dbType="sqlserver" dataSource="localhost\SQLEXPRESS" catalog="DCALDb" uid="datastoredb" pwd="datastoredb" replaceviews="TRUE" /^> >> DbSettings.xml
echo ^<db alias="CMLocal" dbType="sqlserver" dataSource="localhost\SQLEXPRESS" catalog="MCRSCM" uid="datastoredb" pwd="datastoredb" replaceviews="TRUE" /^> >> DbSettings.xml
echo ^<db alias="Master" dbType="sqlserver" dataSource="localhost\SQLEXPRESS" catalog="Master" uid="sa" pwd="datastoredb" replaceviews="TRUE" /^> >> DbSettings.xml
echo ^</root^> >> DbSettings.xml
goto menu_start


:extappOpera

ECHO Closing Simphony...
taskkill /im ServiceHost.exe /t /f
ECHO Creating backup directory...
set bckpdir=C:\Micros\Simphony\Webserver\wwwroot\Egateway\Handlers\ExtensionApplications\Opera.old %date:~-10,2%-%date:~-7,2%-%date:~-4,4% %time:~0,2%.%time:~3,2%.%time:~6,2%
md "%bckpdir%"
ECHO Moving old files to backup directory -> %bckpdir%
forfiles /s /p C:\MICROS\Simphony\WebServer\wwwroot\EGateway\Handlers\ExtensionApplications\ /m Opera  /c "cmd /c move @path 0x22%bckpdir%0x22"
pause
Echo Starting Simphony...
REM C:\Micros\Simphony\WebServer\ServiceHost.exe
goto menu_start



:Windowstools

echo.
echo 		Windows Tools
echo.
echo           -----------------------------------------------------------------
echo.
echo			1 - Provide full permissions over the Micros registry 
echo.
echo			2 - Provide full permissions over the Micros folder and SQLEXPRESS
echo.
echo			3 - TCP Transmissions = 8 (reload db issues
echo.
echo			4 - View last SQL log
echo.
echo			5 - Disable Windows Firewall and advanced firewall
echo.
echo			6 - Disable "Firewall is off" notification
echo.
echo			7 - Lower down User Account Control
echo.
echo			8 - View last Egateway log
echo.
echo			9 - View web.config
echo.
echo	   		10 - View Servicehost.xml
echo.
echo	   		11 - View Simphonyinstall.xml
echo.
echo	  		12 - View DbSettings.xml
echo.
echo	   		13 - View Hosts file
echo.
echo	   		14 - Adjust regional settings - English
echo.
echo	  		15 - Enable auto logon
echo.
echo	  		16 - Enable local Administrator
echo.
echo	  		17 - Back
echo.
echo           -----------------------------------------------------------------
echo.

:menuWindowstools
set /p optionwt=Select 1 or 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9 or 10 or 11 or 12 or 13 or 14 or 15 or 16 or 17?  
echo.
if '%optionwt%'=='1' goto permissionmicrosregistry
if '%optionwt%'=='2' goto permissionmicrosfolder
if '%optionwt%'=='3' goto tcpretransmission8
if '%optionwt%'=='4' goto SQLlog
if '%optionwt%'=='5' goto disablefirewall
if '%optionwt%'=='6' goto disablefirewallnotification
if '%optionwt%'=='7' goto UACdown
if '%optionwt%'=='8' goto viewEgateway
if '%optionwt%'=='9' goto viewWebconfig
if '%optionwt%'=='10' goto viewServicehostxml
if '%optionwt%'=='11' goto viewSimphonyinstall
if '%optionwt%'=='12' goto viewDbSettings
if '%optionwt%'=='13' goto viewHostsfile
if '%optionwt%'=='14' goto adjustregionalsettings
if '%optionwt%'=='15' goto enableautologon
if '%optionwt%'=='16' goto enablelocaladmin
if '%optionwt%'=='17' goto back
echo.


:enablelocaladmin
net user administrator /active:yes	
net user Administrator Welcome1!
echo.
echo  Local Administrator is now enabled. Password: Welcome1!
echo.
Pause						 
goto Windowstools

:enableautologon
control userpasswords2
netplwiz
goto Windowstools
:adjustregionalsettings
:: start regional settings app:								 
echo starting Microsoft Regional settings							 
control intl.cpl
goto Windowstools

:permissionmicrosregistry



goto Windowstools
:permissionmicrosfolderandSQL
if not exist "c:\micros" mkdir "c:\micros"
icacls "C:\Micros" /grant %username%:(OI)(CI)F /T
if not exist "C:\Program Files\MICROS" mkdir "C:\Program Files\MICROS"
icacls "C:\Program Files\MICROS" /grant %username%:(OI)(CI)F /T
if not exist "C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS" mkdir "C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS"
icacls "C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS" /grant %username%:(OI)(CI)F /T
if not exist "C:\Windows\Temp" mkdir "C:\Windows\Temp"
icacls "C:\Windows\Temp" /grant %username%:(OI)(CI)F /T

cls
echo permissions set to following folders for %username%
echo C:\Micros
echo C:\Program Files\MICROS
echo C:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS
echo.
Pause											 
goto Windowstools


:tcpretransmission8
echo Current MaxSynRetransmissions value:
netsh interface tcp show global | findstr "Max SYN Retransmissions"
netsh interface tcp set global MaxSynRetransmissions=8
echo MaxSynRetransmissions are now set to 8.
pause
goto Windowstools




:SQLlog
echo Opening SQL log..
start notepad "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\Log\ERRORLOG"
pause
goto Windowstools


:disablefirewall
::inprogress




goto Windowstools
:disablefirewallnotification 
::in progress..
[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows]

[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion]

[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings]
"SecureProtocols"=dword:00000800

[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\5.0]

[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache]

[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Cache]

[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\DataCollection]

[HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer]
"DisableNotificationCenter"=dword:00000001

echo Notification set to off.

goto Windowstools

:UACdown
::inprogress



goto Windowstools

:viewEgateway
echo Opening last Egateway log file..
start notepad "C:\Micros\Simphony\Webserver\wwwroot\Egateway\Egatewaylog\LOG_%ComputerName%.txt"
pause
goto Windowstools

:viewWebconfig
echo Opening web.config..
start notepad "C:\Micros\Simphony\Webserver\wwwroot\Egateway\web.config.txt"
pause
goto Windowstools



goto Windowstools

:viewServicehostxml

echo Opening web.config..
start notepad "C:\Micros\Simphony\servicehost.xml"
pause
goto Windowstools


:viewSimphonyinstall
echo Opening web.config..
start notepad "C:\Micros\Simphony\Webserver\Simphonyinstall.xml"
pause
goto Windowstools

:viewDbSettings
echo Opening last Egateway log file..
start notepad "C:\Micros\Simphony\Webserver\wwwroot\Egateway\DBSettings.xml"
pause
goto Windowstools


:viewHostsfile
echo Opening last Egateway log file..
start notepad "C:\Windows\System32\drivers\etc\hotsts"
pause
goto Windowstools


:closechecks
echo.
echo 			Select the database
echo           -----------------------------------------------------------------
echo.
echo			1 - CAPS
echo			2 - DataStore
echo.
echo           -----------------------------------------------------------------
echo.

:menuclosechecks

set /p optionm=Select 1 or 2?  
echo.
if '%optionclosecheck%'=='1' goto checkclosebyidCAPS
if '%optionclosecheck%'=='2' goto checkclosebyiddatastore
echo.
echo.

:checkclosebyidCAPS
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
:viewcheckscaps
sqlcmd -S localhost\SQLEXPRESS -Q "select checkid, checknumber, checkopen, checkclose subtotal from checkpostingdb.dbo.checks where checkclose is null"
set /p checkid=checkid of check you want to close or type quit:
if "%checkid%"=="quit" goto quit
sqlcmd -S localhost\SQLEXPRESS -Q "update checkpostingdb.dbo.checks set checkclose = checkopen, closestatus=2 where checkid = %checkid%"
goto viewcheckscaps
:checkclosebyiddatastore
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS /m
:viewchecksdatastore
sqlcmd -S localhost\SQLEXPRESS -Q "select checkid, checknumber, checkopen, checkclose subtotal from DataStore.dbo.checks where checkclose is null"
set /p checkid=checkid of check you want to close or type quit:
if "%checkid%"=="quit" goto quit
sqlcmd -S localhost\SQLEXPRESS -Q "update DataStore.dbo.checks set checkclose = checkopen, closestatus=2 where checkid = %checkid%"
goto viewchedatastore
:quit
echo checks closed and menu quitted
net stop mssql$SQLEXPRESS
net start mssql$SQLEXPRESS
REM C:\Micros\Simphony\WebServer\ServiceHost.exe
goto DatabaseTools




:WorkstationTools
::inprogress


:findALLPrinters
::inprogress


:FindEmployeesInfo
::inprogress


:FindWorkstationsInfo
::inprogress


Pause
