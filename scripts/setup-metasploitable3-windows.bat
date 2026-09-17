@echo off
REM ============================================
REM CyberLab - Metasploitable 3 Windows Configuration
REM IP: 192.168.56.103
REM ============================================

echo ============================================
echo   Configurando Metasploitable 3 - Windows
echo   IP: 192.168.56.103
echo ============================================
echo.

REM Verificar se esta rodando como Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERRO: Execute como Administrador!
    echo Clique com botao direito ^> Executar como administrador
    pause
    exit /b 1
)

REM Configurar IP Estatico
echo Configurando IP...
netsh interface ip set address "Local Area Connection" static 192.168.56.103 255.255.255.0

REM Configurar DNS
echo Configurando DNS...
netsh interface ip set dns "Local Area Connection" static 8.8.8.8
netsh interface ip add dns "Local Area Connection" 8.8.4.4 index=2

echo.
echo ============================================
echo   Metasploitable 3 Windows configurado!
echo   IP: 192.168.56.103
echo   Gateway: 192.168.56.1
echo   DNS: 8.8.8.8
echo ============================================
echo.
echo Teste com: ipconfig
echo Teste conexao: ping 192.168.56.1
echo.
pause
