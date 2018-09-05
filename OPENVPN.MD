# OPENVPN.MD

This is my configuration and setup for my OpenVPN client on my Linux box. My goal is to setup a specific user and route all traffic for that user through the VPN I have setup.

I based a lot of my initial setup on this [guide](https://www.htpcguides.com/force-torrent-traffic-vpn-split-tunnel-debian-8-ubuntu-16-04/) over at HTPCGuides.com and made some adjustments for my configuration that works and met my needs.

## Installation

```bash
apt-get install openvpn sudo apt-utils iptables curl resolvconf -y
cd /etc/openvpn
wget https://github.com/animosity22/homescripts/blob/master/etc/openvpn/openvpn.conf
wget https://github.com/animosity22/homescripts/blob/master/etc/openvpn/iptables.sh
wget https://github.com/animosity22/homescripts/blob/master/etc/openvpn/routing.sh
wget https://github.com/animosity22/homescripts/blob/master/etc/openvpn/update-resolv-conf
```

- Modify the openvpn.conf file and other files to suite your networking needs. My internal network is 192.168.1.0/24 and my server is 192.168.1.30. rTorrent is configured to port forward on 49234 and my iptables rules are configured for that.
- Update login.txt with the proper password information

```bash
# add the vpn user 
 adduser --disabled-login vpn
 # block the vpn user from using the normal network
iptables -F
iptables -A OUTPUT ! -o lo -m owner --uid-owner vpn -j DROP
# save the IPV rules as this will make the vpn user on startup unable to access the normal WAN
apt-get install iptables-persistent -y

# add in the extra route
echo "200     vpn" >> /etc/iproute2/rt_tables

# test the vpn service - for me it installed into /etc/init.d/openvpn
systemctl enable openvpn
systemctl start openvpn

# check status
systemctl status openvpn
```

Status
```bash
systemctl status openvpn
● openvpn.service - OpenVPN service
   Loaded: loaded (/lib/systemd/system/openvpn.service; enabled; vendor preset: enabled)
   Active: active (exited) since Tue 2018-09-04 07:39:33 EDT; 1 day 5h ago
  Process: 845 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 845 (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 4915)
   CGroup: /system.slice/openvpn.service

Sep 04 07:39:33 gemini systemd[1]: Starting OpenVPN service...
Sep 04 07:39:33 gemini systemd[1]: Started OpenVPN service.
```

Other output to confirm

```bash
root@gemini:~ netstat -rn
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG        0 0          0 enp1s0
10.34.0.90      0.0.0.0         255.255.255.255 UH        0 0          0 tun0
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 enp1s0
root@gemini:~ ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 68:05:ca:4e:fa:a0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.30/24 brd 192.168.1.255 scope global enp1s0
       valid_lft forever preferred_lft forever
3: enp2s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 68:05:ca:4e:f6:fc brd ff:ff:ff:ff:ff:ff
8: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none
    inet 10.34.0.89 peer 10.34.0.90/32 scope global tun0
       valid_lft forever preferred_lft forever
root@gemini:~ ip route list
default via 192.168.1.1 dev enp1s0 onlink
10.34.0.90 dev tun0 proto kernel scope link src 10.34.0.89
192.168.1.0/24 dev enp1s0 proto kernel scope link src 192.168.1.30
```

## Checking IP

```bash
curl ipinfo.io
# This should return your normal WAN IP information
#
sudo -u vpn -i -- curl ipinfo.io
# This should return your VPN provider information

# DNS check
sudo -u vpn -i -- cat /etc/resolv.conf

# This should return your modified DNS settings