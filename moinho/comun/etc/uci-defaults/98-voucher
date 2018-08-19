#!/bin/sh
# nododplash config
gwip=$(uci get network.lan.ipaddr)
port=":80"
range=$(uci get network.lm_net_anygw_rule4.src | sed 's/.\{2\}$//')
rangeNum="16"
noConf=$(cat <<EOF
# The options available here are an adaptation of the settings used in nodogsplash.conf.
# See https://github.com/nodogsplash/nodogsplash/blob/master/resources/nodogsplash.conf

config nodogsplash
  # Set to 1 to enable nodogsplash
  option enabled 1

  # Use plain configuration file
  option config '/etc/nodogsplash/nodogsplash.conf'

  # The network the users are connected to
  option network 'lan'
  option gatewayname 'OpenWrt Nodogsplash'
  option maxclients '250'
  option clientidletimeout '1200'

  # Your router may have several interfaces, and you
  # probably want to keep them private from the network/gatewayinterface.
  # If so, you should block the entire subnets on those interfaces, e.g.:
  list authenticated_users 'block to 192.168.0.0/16'
  list authenticated_users 'block to 10.0.0.0/8'

  # Typical ports you will probably want to open up.
  list authenticated_users 'allow tcp port 22'
  list authenticated_users 'allow tcp port 53'
  list authenticated_users 'allow udp port 53'
  list authenticated_users 'allow tcp port 80'
  list authenticated_users 'allow tcp port 443'

  # For preauthenticated users to resolve IP addresses in their
  # initial request not using the router itself as a DNS server,
  list preauthenticated_users 'allow tcp port 53'
  list preauthenticated_users 'allow udp port 53'

  # Allow ports for SSH/Telnet/DNS/DHCP/HTTP/HTTPS
  list users_to_router 'allow tcp port 22'
  list users_to_router 'allow tcp port 23'
  list users_to_router 'allow tcp port 53'
  list users_to_router 'allow udp port 53'
  list users_to_router 'allow udp port 67'
  list users_to_router 'allow tcp port 80'
  list users_to_router 'allow tcp port 443'

  # MAC addresses that are / are not allowed to access the splash page
  # Value is either 'allow' or 'block'. The allowedmac or blockedmac list is used.
  #option macmechanism 'allow'
  #list allowedmac '00:00:C0:01:D0:0D'
  #list allowedmac '00:00:C0:01:D0:1D'
  #list blockedmac '00:00:C0:01:D0:2D'

  #MAC addresses that do not need to authenticate
  #list trustedmac '00:00:C0:01:D0:1D'

EOF
)
config=$(cat <<EOF
GatewayInterface br-lan
GatewayInterfaceExtra bmx+
GatewayInterfaceExtra2 anygw


FirewallRuleSet authenticated-users {
     FirewallRule allow to 0.0.0.0/0
}

FirewallRuleSet users-to-router {                                                                           
 # Nodogsplash automatically allows tcp to GatewayPort,                                                     
 # at GatewayAddress, to serve the splash page.                                                             
 # However you may want to open up other ports, e.g.                                                        
 # 53 for DNS and 67 for DHCP if the router itself is                                                       
 # providing these services.                                                                                
    FirewallRule allow udp port 53                                                                          
    FirewallRule allow tcp port 53                                                                          
    FirewallRule allow udp port 67                                                                          
 # You may want to allow ssh, http, and https to the router                                                 
 # for administration from the GatewayInterface.  If not,                                                   
 # comment these out.                                                                                       
    FirewallRule allow tcp port 22                                                                          
    FirewallRule allow tcp port 80                                                                          
    FirewallRule allow tcp port 443                                                                         
}                                                                                                           
# end FirewallRuleSet users-to-router                                                                       

FirewallRuleSet preauthenticated-users {
 # For preauthenticated users to resolve IP addresses in their initial
 # request not using the router itself as a DNS server,
 # you probably want to allow port 53 udp and tcp for DNS.
    FirewallRule allow tcp port 53	
    FirewallRule allow udp port 53
 # For splash page content not hosted on the router, you
 # will want to allow port 80 tcp to the remote host here.
 # Doing so circumvents the usual capture and redirect of
 # any port 80 request to this remote host.
 # Note that the remote host's numerical IP address must be known
 # and used here.  


     #change the IP for the address of the gateway router
     FirewallRule allow tcp port 80 to $gwip


}
# end FirewallRuleSet preauthenticated-users
 	  
 	  				 	 	 	    		  	

EmptyRuleSetPolicy preauthenticated-users passthrough
EmptyRuleSetPolicy users-to-router passthrough


#change the IP for the address of the gateway router
GatewayName $gwip$port

#GatewayPort 80


MaxClients 500

ClientIdleTimeout 720

ClientForceTimeout 14400


#change the range for the ip range of your mesh network
GatewayIPRange $range$rangeNum

BinVoucher "vale.sh"

ForceVoucher yes

EnablePreAuth yes

EOF
)
# Install nodogsplash and voucher
opkg update && opkg install http://nuvem.tk/files/nodogsplash_0.9.2-1_mips_24kc.ipk
opkg update && opkg install http://nuvem.tk/files/vale_0.1-1_mips_24kc.ipk
echo "Removing old conf"
rm /etc/config/nodogsplash
echo "$noConf" > /etc/config/nodogsplash
echo "Updating splash screen"
mv /etc/nodogsplash/htdocs/splash-vale.html /etc/nodogsplash/htdocs/splash.html
echo "Setting new config for nodogsplash"
echo "$config" > /etc/nodogsplash/nodogsplash.conf
echo "Starting portal"
/etc/init.d/nodogsplash enable
/etc/init.d/nodogsplash start
reboot