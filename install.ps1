# ============================================
# CyberLab - Install Script
# Automatiza toda a instalacao do laboratorio
# ============================================
#
# Uso: .\install.ps1
#
# Requisitos:
# - Windows 10/11 (64-bit)
# - 8GB+ RAM
# - 50GB+ espaco livre
# - Conexao com a internet
#
# ============================================

param(
    [switch]$SkipDownloads,
    [switch]$SkipVMs
)

$ErrorActionPreference = "Stop"
$LabRoot = "C:\CyberLab"
$DownloadsDir = "$LabRoot\Downloads"
$VMsDir = "$LabRoot\VMs"
$ScriptsDir = "$LabRoot\Scripts"

# ============================================
# Funcoes Auxiliares
# ============================================

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Step)
    Write-Host ">>> $Step" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "    OK: $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "    ERRO: $Message" -ForegroundColor Red
}

function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Download-File {
    param(
        [string]$Url,
        [string]$Output,
        [string]$Description
    )
    
    if (Test-Path $Output) {
        Write-Success "$Description ja baixado"
        return
    }
    
    Write-Step "Baixando $Description..."
    try {
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($Url, $Output)
        $size = (Get-Item $Output).Length / 1MB
        Write-Success "$Description baixado ($([math]::Round($size, 2)) MB)"
    } catch {
        Write-Error "Falha ao baixar $Description"
        Write-Host "    URL: $Url" -ForegroundColor Gray
        throw
    }
}

# ============================================
# Verificacoes
# ============================================

Write-Header "CyberLab - Instalador Automatico"

Write-Step "Verificando requisitos..."

# Verificar Windows 64-bit
if ([Environment]::Is64BitOperatingSystem -eq $false) {
    Write-Error "Windows 64-bit e obrigatorio!"
    exit 1
}
Write-Success "Windows 64-bit"

# Verificar espaco em disco
$drive = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
$freeGB = [math]::Round($drive.FreeSpace / 1GB, 2)
if ($freeGB -lt 50) {
    Write-Error "Espaco insuficiente! Necessario: 50GB, Disponivel: ${freeGB}GB"
    exit 1
}
Write-Success "Espaco em disco: ${freeGB}GB disponivel"

# Verificar RAM
$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
if ($ramGB -lt 8) {
    Write-Error "RAM insuficiente! Necessario: 8GB, Disponivel: ${ramGB}GB"
    exit 1
}
Write-Success "RAM: ${ramGB}GB"

# ============================================
# Instalar Dependencias
# ============================================

Write-Header "Instalando Dependencias"

# VirtualBox
Write-Step "Verificando VirtualBox..."
if (Test-Command "VBoxManage") {
    Write-Success "VirtualBox ja instalado"
} else {
    Write-Step "Instalando VirtualBox..."
    winget install Oracle.VirtualBox --silent --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    Write-Success "VirtualBox instalado"
}

# 7-Zip
Write-Step "Verificando 7-Zip..."
if (Test-Path "C:\Program Files\7-Zip\7z.exe") {
    Write-Success "7-Zip ja instalado"
} else {
    Write-Step "Instalando 7-Zip..."
    winget install 7zip.7zip --silent --accept-package-agreements --accept-source-agreements
    Write-Success "7-Zip instalado"
}

# Vagrant
Write-Step "Verificando Vagrant..."
if (Test-Command "vagrant") {
    Write-Success "Vagrant ja instalado"
} else {
    Write-Step "Instalando Vagrant..."
    winget install HashiCorp.Vagrant --silent --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    Write-Success "Vagrant instalado"
}

# Docker
Write-Step "Verificando Docker..."
if (Test-Command "docker") {
    Write-Success "Docker ja instalado"
} else {
    Write-Step "Instalando Docker Desktop..."
    winget install Docker.DockerDesktop --silent --accept-package-agreements --accept-source-agreements
    Write-Success "Docker Desktop instalado"
    Write-Host "    AVISO: Inicie o Docker Desktop antes de usar os apps web" -ForegroundColor Yellow
}

# ============================================
# Criar Diretorios
# ============================================

Write-Header "Criando Estrutura de Diretorios"

$dirs = @($LabRoot, $DownloadsDir, $VMsDir, $ScriptsDir, "$VMsDir\KaliLinux", "$VMsDir\Metasploitable2")
foreach ($dir in $dirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
Write-Success "Diretorios criados"

# ============================================
# Baixar VMs
# ============================================

if (-not $SkipDownloads) {
    Write-Header "Baixando Maquinas Virtuais"
    
    # Kali Linux
    Download-File `
        -Url "https://cdimage.kali.org/kali-images/kali-2026.2/kali-linux-2026.2-virtualbox-amd64.7z" `
        -Output "$DownloadsDir\kali-linux-2026.2-virtualbox-amd64.7z" `
        -Description "Kali Linux 2026.2 (3.7GB)"
    
    # Metasploitable 2
    Download-File `
        -Url "https://sourceforge.net/projects/metasploitable/files/Metasploitable2/metasploitable-linux-2.0.0.zip/download" `
        -Output "$DownloadsDir\metasploitable-linux-2.0.0.zip" `
        -Description "Metasploitable 2 (825MB)"
    
    Write-Step "Baixando Metasploitable 3 (via Vagrant)..."
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    
    if (-not (Test-Path "$env:USERPROFILE\.vagrant.d\boxes\rapid7-metasploitable3-ub1404_*")) {
        vagrant box add rapid7/metasploitable3-ub1404 --provider virtualbox 2>&1 | Out-Null
    }
    Write-Success "Metasploitable 3 Linux baixado"
    
    if (-not (Test-Path "$env:USERPROFILE\.vagrant.d\boxes\rapid7-metasploitable3-win2k8_*")) {
        vagrant box add rapid7/metasploitable3-win2k8 --provider virtualbox 2>&1 | Out-Null
    }
    Write-Success "Metasploitable 3 Windows baixado"
}

# ============================================
# Extrair VMs
# ============================================

if (-not $SkipDownloads) {
    Write-Header "Extraindo Maquinas Virtuais"
    
    $7z = "C:\Program Files\7-Zip\7z.exe"
    
    # Extrair Kali Linux
    $kaliExtracted = Get-ChildItem "$VMsDir\KaliLinux" -Recurse -Filter "*.vdi" -ErrorAction SilentlyContinue
    if (-not $kaliExtracted) {
        Write-Step "Extraindo Kali Linux (pode levar alguns minutos)..."
        & $7z x "$DownloadsDir\kali-linux-2026.2-virtualbox-amd64.7z" -o"$VMsDir\KaliLinux" -y | Out-Null
        Write-Success "Kali Linux extraido"
    } else {
        Write-Success "Kali Linux ja extraido"
    }
    
    # Extrair Metasploitable 2
    $ms2Extracted = Get-ChildItem "$VMsDir\Metasploitable2" -Recurse -Filter "*.vmdk" -ErrorAction SilentlyContinue
    if (-not $ms2Extracted) {
        Write-Step "Extraindo Metasploitable 2..."
        Expand-Archive -Path "$DownloadsDir\metasploitable-linux-2.0.0.zip" -DestinationPath "$VMsDir\Metasploitable2" -Force
        Write-Success "Metasploitable 2 extraido"
    } else {
        Write-Success "Metasploitable 2 ja extraido"
    }
}

# ============================================
# Criar VMs no VirtualBox
# ============================================

if (-not $SkipVMs) {
    Write-Header "Configurando Maquinas Virtuais"
    
    $vbox = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
    
    # Verificar se ja existe
    $existingVMs = & $vbox list vms 2>&1
    
    # Criar Rede NAT Network
    Write-Step "Configurando rede CyberLab..."
    $networks = & $vbox natnetwork list 2>&1
    if ($networks -notmatch "CyberLab") {
        & $vbox natnetwork add --netname "CyberLab" --network "192.168.56.0/24" --enable --dhcp on
    }
    Write-Success "Rede CyberLab configurada (192.168.56.0/24)"
    
    # Kali Linux
    if ($existingVMs -notmatch "KaliLinux-Lab") {
        Write-Step "Criando VM KaliLinux-Lab..."
        $kaliVDI = Get-ChildItem "$VMsDir\KaliLinux" -Recurse -Filter "*.vdi" | Select-Object -First 1
        & $vbox createvm --name "KaliLinux-Lab" --ostype "Debian_64" --register
        & $vbox modifyvm "KaliLinux-Lab" --memory 4096 --cpus 4 --vram 128 --nic1 natnetwork --nat-network1 "CyberLab" --boot1 disk --audio-enabled off
        & $vbox storagectl "KaliLinux-Lab" --name "SATA" --add sata --controller IntelAhci
        & $vbox storageattach "KaliLinux-Lab" --storagectl "SATA" --port 0 --device 0 --type hdd --medium $kaliVDI.FullName
        Write-Success "VM KaliLinux-Lab criada (4GB RAM, 4 CPUs)"
    } else {
        Write-Success "VM KaliLinux-Lab ja existe"
    }
    
    # Metasploitable 2
    if ($existingVMs -notmatch "Metasploitable2-Lab") {
        Write-Step "Criando VM Metasploitable2-Lab..."
        $ms2VMDK = Get-ChildItem "$VMsDir\Metasploitable2" -Recurse -Filter "Metasploitable.vmdk" | Select-Object -First 1
        & $vbox createvm --name "Metasploitable2-Lab" --ostype "Ubuntu" --register
        & $vbox modifyvm "Metasploitable2-Lab" --memory 1024 --cpus 2 --vram 16 --nic1 natnetwork --nat-network1 "CyberLab" --boot1 disk --audio-enabled off
        & $vbox storagectl "Metasploitable2-Lab" --name "SATA" --add sata --controller IntelAhci
        & $vbox storageattach "Metasploitable2-Lab" --storagectl "SATA" --port 0 --device 0 --type hdd --medium $ms2VMDK.FullName
        Write-Success "VM Metasploitable2-Lab criada (1GB RAM, 2 CPUs)"
    } else {
        Write-Success "VM Metasploitable2-Lab ja existe"
    }
    
    # Metasploitable 3 (via Vagrant)
    Write-Step "Configurando Metasploitable 3..."
    Set-Location "$LabRoot\metasploitable3-workspace"
    if (!(Test-Path "Vagrantfile")) {
        Copy-Item "$PSScriptRoot\vagrant\Vagrantfile" "Vagrantfile"
    }
    Write-Success "Metasploitable 3 configurado"
}

# ============================================
# Copiar Scripts
# ============================================

Write-Header "Copiando Scripts de Configuracao"

$scriptFiles = Get-ChildItem "$PSScriptRoot\scripts\*" -File
foreach ($file in $scriptFiles) {
    Copy-Item $file.FullName "$ScriptsDir\$($file.Name)" -Force
    Write-Success "$($file.Name) copiado"
}

# ============================================
# Criar Atalho no Desktop
# ============================================

Write-Header "Criando Atalho no Desktop"

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = "$desktop\CyberLab.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
$shortcut.WorkingDirectory = "C:\Program Files\Oracle\VirtualBox"
$shortcut.Description = "CyberLab - Laboratorio de Cybersecurity"
$shortcut.Save()
Write-Success "Atalho criado no Desktop"

# ============================================
# Resumo Final
# ============================================

Write-Header "INSTALACAO CONCLUIDA!"

Write-Host "VMs Instaladas:" -ForegroundColor Green
Write-Host "  KaliLinux-Lab         - 192.168.56.10   (Atacante)" -ForegroundColor White
Write-Host "  Metasploitable2-Lab   - 192.168.56.101  (Alvo Linux)" -ForegroundColor White
Write-Host "  Metasploitable3-Linux - 192.168.56.102  (Alvo Linux)" -ForegroundColor White
Write-Host "  Metasploitable3-Win   - 192.168.56.103  (Alvo Windows)" -ForegroundColor White
Write-Host ""
Write-Host "Proximos Passos:" -ForegroundColor Yellow
Write-Host "  1. Abra o VirtualBox" -ForegroundColor White
Write-Host "  2. Inicie as VMs" -ForegroundColor White
Write-Host "  3. Execute os scripts de configuracao de IP dentro de cada VM" -ForegroundColor White
Write-Host "  4. Execute start-webapps.bat para apps Docker" -ForegroundColor White
Write-Host ""
Write-Host "Documentacao:" -ForegroundColor Yellow
Write-Host "  C:\CyberLab\README.md" -ForegroundColor White
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Laboratorio pronto para uso!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
