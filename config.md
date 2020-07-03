# System configuration
## Information
OS: Arch Linux
## DNS, resolvconf and OpenVPN
1. Use custom DNS:
```bash
tee /etc/resolv.conf.tail <<EOF
nameserver 1.1.1.1
nameserver 1.0.0.1
EOF
```
2. Blacklist ISP DNS (one may need to adjust the gateway IP)
```bash
tee -a /etc/resolvconf.conf <<EOF
# Prevent ISP DNS from appearing in resolv.conf
name_server_blacklist=10.0.0.1
EOF
```
3. Install openvpn-update-resolv-conf-git from AUR and update OpenVPN client configuration
```bash
tee -a /etc/openvpn/client/client.conf <<EOF
script-security 2
up /etc/openvpn/update-resolv-conf
down /etc/openvpn/update-resolv-conf
EOF
```
