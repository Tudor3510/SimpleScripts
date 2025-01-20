# Asus RT-AC53

- IPv6 Auto Configuration supports Stateless and Stateful modes
- Router Advertisement (RA) can be disabled, but this may affect IPv6 address assignment
- IPv6 WAN can be configured with up to three DNS servers, but clients only receive one DNS server
- The router's gateway link-local address is not fe80::1; it is generated in a MAC-derived format
- IPv4 WAN allows up to two DNS servers

## Notes

The available options for IPv6 Auto Configuration are Stateless and Stateful. There is also an option to disable Router Advertisement (RA). However, I am not entirely sure how this works. For example, when I set the mode to Stateless and disabled Router Advertisement, my Android device was unable to obtain an IPv6 address.

For the IPv6 WAN connection, you can manually configure up to three DNS servers. However, client devices will only receive one DNS server, which is the LAN IPv6 address of the router (not the link-local address).

Regarding the gateway's link-local address, it is not fe80::1. Instead, the router generates it using a format that appears to be derived from its MAC address (starting with fe80::).

In contrast, for IPv4 WAN settings, you can manually configure up to two DNS servers.

## Disclaimer

This document records personal troubleshooting notes and observations from local testing. It is not affiliated with, endorsed by, or sponsored by ASUS, Asus, device manufacturers, or any related vendor. The information is provided for informational and documentation purposes only and should not be interpreted as official support, product documentation, or a legal or contractual commitment. Use it at your own discretion and verify independently before relying on it in production, business, security-sensitive, or regulated environments.
