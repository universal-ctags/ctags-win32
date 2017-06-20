@echo off
echo on

cd %APPVEYOR_BUILD_FOLDER%

if "%APPVEYOR_REPO_TAG_NAME%"=="" (
  if "%1"=="build" (
    goto update_repo
  )
) else (
  goto call_submodule
)
goto :eof

:call_submodule
set OLD_APPVEYOR_BUILD_FOLDER=%APPVEYOR_BUILD_FOLDER%
set APPVEYOR_BUILD_FOLDER=%APPVEYOR_BUILD_FOLDER%\ctags
call ctags\win32\appveyor.bat %1
set APPVEYOR_BUILD_FOLDER=%OLD_APPVEYOR_BUILD_FOLDER%
goto :eof


:update_repo
path C:\%MSYS2_DIR%\usr\bin;%PATH%
set CHERE_INVOKING=yes
bash -lc "git config user.name '%DEPLOY_USER_NAME%'; git config user.email '%DEPLOY_USER_EMAIL%'"
bash -lc "file ./scripts/update-repo.sh"
bash -lc "./scripts/update-repo.sh"
goto :eof
