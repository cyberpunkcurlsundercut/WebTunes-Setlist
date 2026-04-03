@echo off
setlocal enabledelayedexpansion

set "root="

for /r "%root%" %%F in (*.mp3) do (
    REM Get folder path
    set "folder=%%~dpF"
    set "folder_no_slash=!folder:~0,-1!"

    REM Extract full folder name (preserve dots and brackets)
    for %%X in ("!folder_no_slash!") do set "foldername=%%~nxX"

    REM --- Normalize foldername only if it starts with a year ---
    if "!foldername:~0,1!"=="[" (
        set "year=!foldername:~1,4!"
        for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
        if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
            set "foldername=!foldername:~6!"
        )
    ) else if "!foldername:~0,1!"=="(" (
        set "year=!foldername:~1,4!"
        for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
        if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
            set "foldername=!foldername:~6!"
        )
    ) else (
        set "year=!foldername:~0,4!"
        for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
        if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
            set "foldername=!foldername:~5!"
        )
    )

    REM Trim leading spaces
    for /f "tokens=* delims= " %%Y in ("!foldername!") do set "foldername=%%Y"

    echo Processing: %%F
    echo Saving as: !folder!!foldername!.jpg

    REM Extract embedded cover art (if present)
    ffmpeg -i "%%F" -map 0:v:0 -c copy "!folder!!foldername!.jpg" -y
)

echo.
echo DONE
pause
