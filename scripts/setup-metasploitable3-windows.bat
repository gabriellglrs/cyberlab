@echo off
REM ============================================
REM CyberLab - Metasploitable 3 Windows Configuration
REM IP: 192.168.56.103 (Internal Network)
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

REM Listar placas de rede
echo Placas de rede disponiveis:
netsh interface show interface
echo.

REM Configurar IP Estatico na segunda placa (Internal Network)
echo Configurando IP na Internal Network...
netsh interface ip set address "Ethernet 2" static 192.168.56.103 255.255.255.0

REM Configurar DNS
echo Configurando DNS...
netsh interface ip set dns "Ethernet 2" static 8.8.8.8

echo.
echo ============================================
echo   Metasploitable 3 Windows configurado!
echo   IP: 192.168.56.103
echo   Placa: Ethernet 2 (Internal Network)
echo   DNS: 8.8.8.8
echo ============================================
echo.
echo Teste com: ipconfig
echo Teste conexao: ping 192.168.56.10
echo.
pause
