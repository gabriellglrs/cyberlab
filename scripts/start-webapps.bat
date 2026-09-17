@echo off
REM ============================================
REM CyberLab - Start Vulnerable Web Applications
REM ============================================

echo ============================================
echo   CyberLab - Apps Web Vulneraveis
echo ============================================
echo.

REM Verificar Docker
echo Verificando Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Docker nao encontrado!
    echo Instale o Docker Desktop: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Verificar se Docker esta rodando
docker ps >nul 2>&1
if errorlevel 1 (
    echo ERRO: Docker nao esta rodando!
    echo Abra o Docker Desktop e aguarde inicializar.
    pause
    exit /b 1
)

echo Docker OK!
echo.

REM Iniciar OWASP Juice Shop
echo Iniciando OWASP Juice Shop (porta 3000)...
docker run -d --name juice-shop -p 3000:3000 bkimminich/juice-shop 2>nul
if errorlevel 1 (
    echo AVISO: Juice Shop ja pode estar rodando ou imagem nao encontrada.
    echo Tentando iniciar container existente...
    docker start juice-shop 2>nul
)

REM Iniciar DVWA
echo Iniciando DVWA (porta 8080)...
docker run -d --name dvwa -p 8080:80 vulnerables/web-dvwa 2>nul
if errorlevel 1 (
    echo AVISO: DVWA ja pode estar rodando ou imagem nao encontrada.
    echo Tentando iniciar container existente...
    docker start dvwa 2>nul
)

echo.
echo ============================================
echo   Apps Web Iniciados!
echo ============================================
echo.
echo   Juice Shop:  http://localhost:3000
echo   DVWA:        http://localhost:8080
echo.
echo   Credenciais DVWA: admin / password
echo.
echo   Para parar: docker stop juice-shop dvwa
echo   Para remover: docker rm -f juice-shop dvwa
echo.
pause
