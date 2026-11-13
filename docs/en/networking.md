# Network access and ports

Network access is controlled by the daemon and policy gateway. The default profile is `deny-all`; an agent cannot use outbound networking until a rule permits it.

## Allow outbound traffic

Create-time rules accept IPv4 CIDRs with an optional port. TCP is the default; prefix a rule with `udp:` for UDP:

```sh
rsbx run --allow-network 203.0.113.8/32:443 shell .
rsbx run --allow-network udp:203.0.113.53/32:53 shell .
```

Use documentation-only example addresses above; replace them with destinations the task actually needs. Explicit deny rules take priority over allows. Global and sandbox rules are shown by `rsbx policy ls`.

Domain rules require a configured DNS upstream and compatible patched gateway. Domain-aware TLS enforcement remains experimental; encrypted ClientHello, domain-only UDP, and overlapping direct-IP rules have documented restrictions. Do not treat a domain allow as a general DNS or HTTP filter.

## Publish a service

Published guest ports bind to host loopback. They are not exposed to other machines on the network:

```sh
rsbx run --publish 127.0.0.1:8080:3000 shell .
rsbx ports my-sandbox
```

The protocol can be TCP or UDP. IPv4 and IPv6 loopback forms are available on supported gateway builds. A guest listener must bind to an address reachable from the sandbox interface, commonly `0.0.0.0`.

Port publishing allows host-to-guest connections. It does not grant outbound access from the guest. Configure egress rules separately.

## Inspect and change policy

```sh
rsbx policy ls my-sandbox
rsbx policy allow network --sandbox my-sandbox 203.0.113.8/32:443
rsbx policy deny network --sandbox my-sandbox 203.0.113.8/32:443
```

The local `policy check` command evaluates stored rules. It is not a live query to the gateway and does not prove that a packet will pass.

## Limits

Gateway validation remains platform- and build-specific. Complete IPv6 egress, QUIC/DoH bypass, HTTP-layer filtering, and independent security review are not established. See the [security guide](security.md) for the current scope.
