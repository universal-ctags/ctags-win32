@echo off

cd %APPVEYOR_BUILD_FOLDER%

if "%APPVEYOR_REPO_TAG_NAME%"=="" (
  if "%1_%ARCH%"=="build_x64" (
    goto update_repo
  )
  echo Build skipped.
  appveyor exit
) else (
  goto call_submodule
)
goto :eof


:call_submodule
echo on

git submodule init
git submodule update
set OLD_APPVEYOR_BUILD_FOLDER=%APPVEYOR_BUILD_FOLDER%
set APPVEYOR_BUILD_FOLDER=%APPVEYOR_BUILD_FOLDER%\ctags
call ctags\win32\appveyor.bat %1
set APPVEYOR_BUILD_FOLDER=%OLD_APPVEYOR_BUILD_FOLDER%

@echo off
goto :eof


:update_repo
echo on
path C:\%MSYS2_DIR%\usr\bin;%PATH%
set CHERE_INVOKING=yes

@git config user.name "%DEPLOY_USER_NAME%"
@git config user.email "%DEPLOY_USER_EMAIL%"
git remote set-url --push origin "git@github.com:%APPVEYOR_REPO_NAME%.git"

if not "%APPVEYOR_SCHEDULED_BUILD%"=="True" (
  @rem Skip if the commit is tagged.
  git describe --tags --exact-match > NUL 2>&1
  if not ERRORLEVEL 1 (
    @echo Build skipped.
    goto end_update
  )
)

set MSYSTEM=MSYS
bash -lc "mkdir -p ~/.ssh; sh ./scripts/install_sshkey_github.sh ./scripts/ci-uctags-win32.enc ~/.ssh/ci-uctags-win32"
bash -lc "sh ./scripts/update-repo.sh"

:end_update
appveyor exit
@echo off
goto :eof
