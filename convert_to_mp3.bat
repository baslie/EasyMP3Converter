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
echo Конвертер аудио- и видеофайлов в MP3
echo ==============================

:: Проверяем наличие медиафайлов (аудио- и видео) для обработки
set found_files=0
for %%f in ("*.wav" "*.ogg" "*.flac" "*.aac" "*.wma" "*.m4a" "*.mp4" "*.avi" "*.mov" "*.mkv" "*.mpg" "*.mpeg") do (
    set found_files=1
    goto :process_files
)

if %found_files%==0 (
    echo [Информация] Медиафайлы для обработки не найдены в текущей папке.
    pause
    exit /b
)

:process_files
:: Проходим по всем медиафайлам в текущей папке
for %%f in ("*.wav" "*.ogg" "*.flac" "*.aac" "*.wma" "*.m4a" "*.mp4" "*.avi" "*.mov" "*.mkv" "*.mpg" "*.mpeg") do (
    :: Если MP3 с тем же именем уже существует, пропускаем
    if not exist "%%~nf.mp3" (
        echo [Обработка] %%~nf%%~xf
        ffmpeg -i "%%f" -q:a 2 "%%~nf.mp3" >nul 2>nul
        if errorlevel 1 (
            echo [Ошибка] Не удалось обработать файл: %%~nf%%~xf
        ) else (
            echo [Готово] Файл успешно конвертирован: %%~nf.mp3
        )
    ) else (
        echo [Пропущено] MP3 уже существует: %%~nf.mp3
    )
)

echo ==============================
echo Конвертация завершена.
pause
