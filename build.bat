mkdir C:\build\ReduxUI_%1\ReduxUI
xcopy ..\ReduxUI C:\build\ReduxUI_%1\ReduxUI /s
7z a -xr!*.bat C:\build\ReduxUI_%1\ReduxUI_%1.zip C:\build\ReduxUI_%1\ReduxUI