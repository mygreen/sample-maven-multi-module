@echo off

if NOT "%JAVA_HOME_11%" == "" (
    set JAVA_HOME="%JAVA_HOME_11%"
)

set PATH=%PATH%;%JAVA_HOME%\bin;%M2_HOME%\bin;

rem 処理対象のMavenのプロジェクト(exampleプロジェクトは除外する)
set MVN_SITE_PROJECT_LIST="!sample,!sample/sample-sub-module1,!sample/sample-sub-module2"
set MVN_DEPLOY_PROJECT_LIST="!sample,!sample/sample-sub-module1,!sample/sample-sub-module2,!report-aggregate"

