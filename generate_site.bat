@echo off

%~d0
cd %~p0

set LOG_FILE="target/site.log"
rem set MAVEN_OPTS="-Xmx1024m"

call env.bat

call mvn clean

mkdir target
call mvn --version > %LOG_FILE% 2>&1 
call mvn site -pl %MVN_SITE_PROJECT_LIST% >> %LOG_FILE% 2>&1 

echo 集約された jacoco-report のコピー
xcopy /Y /E /Q report-aggregate\target\site\jacoco-aggregate target\site\jacoco-aggregate >> %LOG_FILE% 2>&1 

echo 各モジュールのサイトのコピー
xcopy /S /Y /E /Q /I parent\target\site target\site\parent
xcopy /S /Y /E /Q /I parent\module1\target\site target\site\parent\module1
xcopy /S /Y /E /Q /I parent\module2\target\site target\site\parent\module2
xcopy /S /Y /E /Q /I parent\module2\module2-sub-module1\target\site target\site\parent\module2\module2-sub-module1
xcopy /S /Y /E /Q /I parent\module2\module2-sub-module2\target\site target\site\parent\module2\module2-sub-module2


REM github-pagesの対応
echo "" > .\target\site\.nojekyll

rem start target/site.log

pause
