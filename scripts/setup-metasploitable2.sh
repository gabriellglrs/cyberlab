# ============================================
# CyberLab - Metasploitable 2 Network Configuration
# IP: 192.168.56.101
# ============================================

#!/bin/bash

echo "============================================"
echo "  Configurando Metasploitable 2 - Alvo"
echo "  IP: 192.168.56.101"
echo "============================================"
echo ""

# Backup do arquivo original
sudo cp /etc/network/interfaces /etc/network/interfaces.bak 2>/dev/null

# Configuracao de rede
sudo cat > /etc/network/interfaces << 'EOF'
# Loopback
auto lo
iface lo inet loopback

# Rede Principal - CyberLab (Alvo Linux)
auto eth1
iface eth1 inet static
    address 192.168.56.101
    netmask 255.255.255.0
EOF

# Reiniciar rede
sudo /etc/init.d/networking restart 2>/dev/null || sudo service networking restart

echo ""
echo "============================================"
echo "  Metasploitable 2 configurado!"
echo "  IP: 192.168.56.101"
echo "  Gateway: 192.168.56.1"
echo "  DNS: 8.8.8.8"
echo "============================================"
echo ""
echo "Teste com: ip a"
echo "Teste conexao: ping 192.168.56.1"
echo ""
