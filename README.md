Services

1. Prevent DHCP from slowing startup
sudo cp services/dhcpcd-no-wait.conf /etc/systemd/system/dhcpcd@.service.d/no-wait.conf
2. Lock X session
sudo cp services/lock@.service /etc/systemd/system/


Config
1. DNS resolution
sudo cp config/dhcpcd/resolv.conf.head /etc
