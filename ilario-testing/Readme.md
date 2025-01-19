= 2025-01 - Testing pull requests for release 2024.1

#1161: [network: Do not configure protocols on DSA switch port network devices by default.](https://github.com/libremesh/lime-packages/pull/1161) by pony1k

#1158: [Watchping: increase wait time for interface to get up](https://github.com/libremesh/lime-packages/pull/1158) by ilario

#1154: [Scrape device names from board.json](https://github.com/libremesh/lime-packages/pull/1154) by pony1k

legend:
--- wired connection
··· wifi connection

== Scenario 1 - DSA-DSA cabled connection

To test what happens when two routers with DSA-supported switches are connected via ethernet cable on the LAN ports.

Internet --- Ubiquiti NanoStation LoCo M2 XM ··· PlasmaCloud PA1200 --- YouHua WR1200JS ··· TP-Link WDR3600 ··· laptop

Ubiquiti NanoStation LoCo M2 XM and PlasmaCloud PA1200 have mesh only on 2.4 GHz

YouHua WR1200JS and TP-Link WDR3600 have mesh only on 5 GHz

=== Scenario 1a

No additional configuration.

Results: PlasmaCloud and YouHua WR1200JS do not see each other as the ethernet interfaces are configured to be just for LAN clients, thanks to #1161.

=== Scenario 1b

`ethernet1` for PA1200 and `lan1` for YouHua have been configured to not be part of LAN bridge but to be used for the routing protocols.

Results: ping from the laptop to the internet has 0% packet loss.

== Scenario 2

To test what happens when a router with a DSA-supported switch is connected to a router with only swconfig-supported switch via ethernet cable on the LAN ports.

Internet --- PlasmaCloud PA1200 ··· YouHua WR1200JS --- Ubiquiti NanoStation LoCo M2 XM ··· TP-Link WDR3600 --- laptop

Ubiquiti NanoStation LoCo M2 XM and TP-Link WDR3600 have mesh only on 2.4 GHz

YouHua WR1200JS and PlasmaCloud PA1200 have mesh only on 5 GHz

=== Scenario 2a

No additional configuration.

Results: laptop cannot ping the internet.

=== Scenario 2b

`lan1` for YouHua has been configured to not be part of LAN bridge but to be used for the routing protocols.

Results: just 0.1 % of packet loss, very good. Observed this message in the logs of the YouHua: "br-lan: received packet on bat0 with own address as source address (addr:d4:5f:25:eb:7e:ac, vlan:0)". Unexpectedly, SSH did not allow me to connect to most routers for a while.

== Scenario 3

Internet --- YouHua WR1200JS ··· TP-Link WDR3600 --- Ubiquiti NanoStation M2 LoCo XM ··· PlasmaCloud PA1200 --- laptop

YouHua and WDR3600 have mesh only on 5 GHz.

NS-M2 and PA1200 have mesh only on 2.4 GHz.

=== Scenario 3a

No additional configuration.

Results: ping was working with 0% packet loss. After reboot, ping sometimes started immediately, sometimes it took long time, but ssh took long time before allowing me to connect to any router but the first one closest to the laptop. The packets, as seen from my laptop, are in the file 202501-setup3-ssh.pcapng and they seem like that the answers are not reaching the YouHua WR1200JS that I was trying to connect to. Then suddenly ssh started working again.

Trying to see how often this happens:

==== Boot #1:
PA1200 answers to ping and httping after approx 1 min from reboot. Reachable via ssh.

NS-M2 answers to ping after approx 2 min from reboot. Reachable via ssh.

YouHua, WDR3600 and internet are not reachable via ping nor httping after 15 min.

==== Boot #2:
PA1200 answers after 1 min. NS-M2 after 1.5 min. YouHua, WDR3600 and internet after 2 min. All of them reachable via ssh.


==== Boot #3, #4, #5, #6, #7, #8, #9, #10:
Exactly the same as in boot #2.

Cannot replicate.

Speed test says 67 Mbps download and 45 Mbps upload.

=== Scenario 3b

`eth0.1` on WDR3600 and `eth0` on NS-M2 have been configured to be only used for the routing protocols, not added to the LAN bridge.

Speed test says 63 Mbps download and 44 Mbps upload.

==== Boot #1:

Internet connection works, but cannot connect to ssh of any router but the PA1200.

Rebooting with reboot command

==== Boot #2: 

Same as #1

Rebooted removing power from all routers and giving it back.

Connecting via wifi to the WDR3600 I was able to connect via ssh to the NS-M2 unit. So it was a problem only when the connection was incoming from the wifi mesh.

==== Boot #3:

Everything works fine.

Rebooting with reboot command.

==== Boot #4:

Everything works fine. Mah.

Running lime-config and rebooting with the reboot command

==== Boot #5:

Everything works fine.

== Conclusions

The three tested pull requests are good to merge.

For the routers with non-DSA switches (the ones that are still managed with swconfig), there is no need to remove the ethernet port from the LAN bridge.

For the routers with DSA-supported switched, the ethernet interfaces have to be either in the LAN bridge or in the routing protocols. The proposed solution to have them only in the LAN bridge by default is good.

Sometimes I observed issues with the Ubiquiti NanoStation LoCo M2 XM apparently dropping packets for ssh connections to it and to the next routers if the connection was incoming from the wireless mesh. I could not reproduce nor identify why this is happening.

