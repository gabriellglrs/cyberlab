# 🌐 CyberLab - Documentação da Rede

## Visão Geral da Rede

O CyberLab utiliza uma rede **NAT Network** do VirtualBox chamada `CyberLab` para isolar completamente as VMs da rede externa.

## Configuração da Rede

| Propriedade | Valor |
|-------------|-------|
| **Nome** | CyberLab |
| **Tipo** | NAT Network |
| **Sub-rede** | 192.168.56.0/24 |
| **Máscara** | 255.255.255.0 |
| **Gateway** | 192.168.56.1 |
| **DHCP** | Ativo (192.168.56.100 - 192.168.56.200) |
| **DNS** | 8.8.8.8, 8.8.4.4 |

## Mapa de Endereços IP

```
┌─────────────────────────────────────────────────────────────────┐
│                    REDE CyberLab (192.168.56.0/24)               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  .1      .10         .101        .102        .103               │
│  │       │           │           │           │                   │
│  ▼       ▼           ▼           ▼           ▼                   │
│  ┌───┐  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │GW │  │  KALI   │ │  MS2    │ │ MS3-LIN │ │ MS3-WIN │       │
│  │   │  │ Atacante│ │  Alvo   │ │  Alvo   │ │  Alvo   │       │
│  └───┘  └─────────┘ └─────────┘ └─────────┘ └─────────┘       │
│                                                                  │
│  Portas:                                                        │
│  ├─ .101: 21,22,23,25,80,139,445,3306,5432,8080               │
│  ├─ .102: 21,22,23,25,80,139,445,3306,8080,8181,8443          │
│  └─ .103: 21,22,80,135,139,445,3389,5985,5986                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Tabela de Endereçamento Completa

### Máquinas Virtuais

| Máquina | IP | MAC | RAM | CPUs | Gateway | DNS |
|---------|-----|-----|-----|------|---------|-----|
| KaliLinux-Lab | 192.168.56.10 | 08:00:27:00:00:10 | 4 GB | 4 | 192.168.56.1 | 8.8.8.8 |
| Metasploitable2-Lab | 192.168.56.101 | 08:00:27:00:00:65 | 1 GB | 2 | 192.168.56.1 | 8.8.8.8 |
| Metasploitable3-Linux | 192.168.56.102 | 08:00:27:D7:0C:43 | 2 GB | 2 | 192.168.56.1 | 8.8.8.8 |
| Metasploitable3-Windows | 192.168.56.103 | 08:00:27:XX:XX:XX | 4 GB | 2 | 192.168.56.1 | 8.8.8.8 |

### Portas por Máquina

#### Kali Linux (192.168.56.10)
| Porta | Serviço | Status |
|-------|---------|--------|
| 22 | SSH (OpenSSH) | Ativo |

#### Metasploitable 2 (192.168.56.101)
| Porta | Serviço | Versão | Vulnerabilidade |
|-------|---------|--------|-----------------|
| 21 | FTP | vsftpd 2.3.4 | Backdoor (CVE-2011-2523) |
| 22 | SSH | OpenSSH 4.7p1 | - |
| 23 | Telnet | - | Senha em texto plano |
| 25 | SMTP | Postfix | - |
| 80 | HTTP | Apache 2.2.8 | PHP vulnerabilities |
| 139 | SMB | Samba 3.0.20 | Usermap Script (CVE-2007-2447) |
| 445 | SMB | Samba 3.0.20 | Usermap Script |
| 3306 | MySQL | 5.0.51a | - |
| 5432 | PostgreSQL | 8.3.0 | - |
| 8080 | HTTP | Tomcat 6.0.18 | Manager bypass |

#### Metasploitable 3 Linux (192.168.56.102)
| Porta | Serviço | Versão | Vulnerabilidade |
|-------|---------|--------|-----------------|
| 21 | FTP | ProFTPd 1.3.5 | mod_copy |
| 22 | SSH | OpenSSH 6.6.1 | - |
| 23 | Telnet | - | Senha em texto plano |
| 25 | SMTP | Postfix | - |
| 80 | HTTP | Apache 2.4.7 | - |
| 139 | SMB | Samba | - |
| 445 | SMB | Samba | - |
| 3306 | MySQL | 5.5.40 | - |
| 8080 | HTTP | GlassFish 4.0 | Admin bypass |
| 8181 | HTTPS | GlassFish 4.0 | - |
| 8443 | HTTPS | GlassFish 4.0 | - |

#### Metasploitable 3 Windows (192.168.56.103)
| Porta | Serviço | Versão | Vulnerabilidade |
|-------|---------|--------|-----------------|
| 21 | FTP | - | - |
| 22 | SSH | OpenSSH | - |
| 80 | HTTP | IIS 7.5 | - |
| 135 | RPC | Windows | - |
| 139 | SMB | Windows | - |
| 445 | SMB | Windows | MS08-067, MS17-010 |
| 3389 | RDP | Windows | - |
| 5985 | WinRM | Windows | - |
| 5986 | WinRM | Windows | HTTPS |

## Fluxo de Tráfego

```
┌─────────────────────────────────────────────────────────────────┐
│                         FLUXO DE TRÁFEGO                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. KALI (.10) escaneia METASPLOITABLE 2 (.101)                 │
│     │                                                            │
│     └─▶ nmap -sV 192.168.56.101                                 │
│         │                                                        │
│         └─▶ Portas abertas: 21,22,23,25,80,139,445,3306...      │
│                                                                  │
│  2. KALI (.10) explora METASPLOITABLE 2 (.101)                  │
│     │                                                            │
│     └─▶ msfconsole                                              │
│         │                                                        │
│         └─▶ use exploit/unix/ftp/vsftpd_234_backdoor            │
│             │                                                    │
│             └─▶ set RHOSTS 192.168.56.101                       │
│                 │                                                │
│                 └─▶ exploit                                      │
│                     │                                            │
│                     └─▶ Shell aberto!                            │
│                                                                  │
│  3. KALI (.10) testa web apps                                   │
│     │                                                            │
│     └─▶ http://192.168.56.101/dvwa                              │
│         │                                                        │
│         └─▶ SQL Injection, XSS, Command Injection...            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Configuração de Rede por VM

### Kali Linux

```bash
# /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.56.10
    netmask 255.255.255.0
    gateway 192.168.56.1
    dns-nameservers 8.8.8.8 8.8.4.4
```

### Metasploitable 2

```bash
# /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.56.101
    netmask 255.255.255.0
    gateway 192.168.56.1
    dns-nameservers 8.8.8.8 8.8.4.4
```

### Metasploitable 3 Linux

```bash
# /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.56.102
    netmask 255.255.255.0
    gateway 192.168.56.1
    dns-nameservers 8.8.8.8 8.8.4.4
```

### Metasploitable 3 Windows

```powershell
# PowerShell (como Administrador)
netsh interface ip set address "Local Area Connection" static 192.168.56.103 255.255.255.0 192.168.56.1
netsh interface ip set dns "Local Area Connection" static 8.8.8.8
netsh interface ip add dns "Local Area Connection" 8.8.4.4 index=2
```

## Verificação de Conectividade

```bash
# Do Kali Linux, teste todos os alvos:
ping -c 3 192.168.56.1     # Gateway
ping -c 3 192.168.56.101   # Metasploitable 2
ping -c 3 192.168.56.102   # Metasploitable 3 Linux
ping -c 3 192.168.56.103   # Metasploitable 3 Windows

# Scan completo da rede
nmap -sn 192.168.56.0/24
```

---

**Última atualização:** Setembro 2026
