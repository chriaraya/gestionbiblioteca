@echo off
setlocal
cd /d "%~dp0"

where java >nul 2>nul
if errorlevel 1 (
    echo Java no esta instalado o no esta configurado en PATH.
    echo Instala Java 17 o superior y vuelve a intentarlo.
    pause
    exit /b 1
)

if not exist "%~dp0target\gestionbiblioteca-1.0.0.jar" (
    echo No se encontro el JAR ejecutable.
    echo Abre el proyecto en IntelliJ y ejecuta Maven ^> Lifecycle ^> package.
    pause
    exit /b 1
)

java -jar "%~dp0target\gestionbiblioteca-1.0.0.jar"
if errorlevel 1 (
    echo La aplicacion termino con un error. Revisa la configuracion local.
    pause
    exit /b 1
)

endlocal
