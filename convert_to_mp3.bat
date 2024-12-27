@echo off
:: Установка правильной кодировки для консоли
chcp 65001 >nul

:: Проверяем, установлен ли FFmpeg
where ffmpeg >nul 2>nul
if errorlevel 1 (
    echo [Ошибка] FFmpeg не найден. Убедитесь, что FFmpeg установлен и добавлен в PATH.
    pause
    exit /b
)

:: Вывод приветственного сообщения
echo ==============================
echo Конвертер аудиофайлов в MP3
echo ==============================

:: Проверяем наличие аудиофайлов для обработки
set found_files=0
for %%f in ("*.wav" "*.ogg" "*.flac" "*.aac" "*.wma" "*.m4a") do (
    set found_files=1
    goto :process_files
)

if %found_files%==0 (
    echo [Информация] Аудиофайлы для обработки не найдены в текущей папке.
    pause
    exit /b
)

:process_files
:: Проходим по всем аудиофайлам в текущей папке
for %%f in ("*.wav" "*.ogg" "*.flac" "*.aac" "*.wma" "*.m4a") do (
    if not exist "%%~nf.mp3" (
        echo [Обработка] %%~nf%%~xf
        ffmpeg -i "%%f" -q:a 2 "%%~nf.mp3" >nul 2>nul
        if errorlevel 1 (
            echo [Ошибка] Не удалось обработать файл: %%~nf%%~xf
        ) else (
            echo [Готово] Файл успешно конвертирован: %%~nf.mp3
        )
    ) else (
        echo [Пропущено] Файл уже существует: %%~nf.mp3
    )
)

echo ==============================
echo Конвертация завершена.
pause
