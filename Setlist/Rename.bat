@echo off
setlocal enabledelayedexpansion

set "root=C:\Users\krisk\Downloads\WebTunes-Setlist\Setlist\Guns N' Roses"

:: --- Folders ---
for /d %%F in ("%root%\*") do (
    set "folder=%%~nxF"
    set "newname=!folder!"

    rem remove [YYYY] at start
    if "!newname:~0,1!"=="[" (
        set "year=!newname:~1,4!"
        for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
        if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
            set "newname=!newname:~6!"
        )
    )

    rem remove (YYYY) at start
    if "!newname:~0,1!"=="(" (
        set "year=!newname:~1,4!"
        for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
        if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
            set "newname=!newname:~6!"
        )
    )

    rem remove plain YYYY at start
    set "year=!newname:~0,4!"
    for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
    if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
        set "newname=!newname:~5!"
    )

    rem trim leading spaces and dashes
    for /f "tokens=* delims= " %%X in ("!newname!") do set "newname=%%X"
    if "!newname:~0,1!"=="-" set "newname=!newname:~1!"
    for /f "tokens=* delims= " %%X in ("!newname!") do set "newname=%%X"

    if not "!folder!"=="!newname!" ren "%%F" "!newname!"

    :: --- Step 3: normalize disc subfolders ---
    for /d %%A in ("%%F\*") do (
        set "sub=%%~nxA"
        set "subclean=!sub!"

        for /f "tokens=1,2 delims= -" %%P in ("!subclean!") do (
            if /i "%%P"=="CD"   set "subclean=CD-%%Q"
            if /i "%%P"=="Disc" set "subclean=CD-%%Q"
        )

        if not "!sub!"=="!subclean!" ren "%%A" "!subclean!"
    )
)

:: --- Covers ---
for /r "%root%" %%I in (*.jpg *.jpeg *.png) do (
    set "fname=%%~nxI"
    set "newfile=!fname!"

    rem remove [YYYY] at start
    if "!newfile:~0,1!"=="[" (
        set "year=!newfile:~1,4!"
        for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
        if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
            set "newfile=!newfile:~6!"
        )
    )

    rem remove (YYYY) at start
    if "!newfile:~0,1!"=="(" (
        set "year=!newfile:~1,4!"
        for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
        if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
            set "newfile=!newfile:~6!"
        )
    )

    rem remove plain YYYY at start
    set "year=!newfile:~0,4!"
    for /f "delims=0123456789" %%Z in ("!year!") do set "nonDigit=%%Z"
    if "!nonDigit!"=="" if "!year!" geq "1980" if "!year!" leq "2026" (
        set "newfile=!newfile:~5!"
    )

    rem trim leading spaces and dashes
    for /f "tokens=* delims= " %%X in ("!newfile!") do set "newfile=%%X"
    if "!newfile:~0,1!"=="-" set "newfile=!newfile:~1!"
    for /f "tokens=* delims= " %%X in ("!newfile!") do set "newfile=%%X"

    if not "!fname!"=="!newfile!" ren "%%I" "!newfile!"
)

echo DONE
pause
