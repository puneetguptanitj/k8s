easyrsa init-pki
easyrsa build-ca nopass
easyrsa --req-cn=kubernetes --req-org=kubernetes --use-algo=rsa --keysize=2048 --req-email= --dn-mode=org  --subject-alt-name=DNS:localhost,DNS:kubernetes.local,IP:127.0.0.1,IP:192.168.33.10,IP:192.168.33.11,IP:192.168.33.12 gen-req kubernetes nopass
easyrsa --subject-alt-name=DNS:localhost,DNS:kubernetes.local,IP:127.0.0.1,IP:192.168.33.10,IP:192.168.33.11,IP:192.168.33.12 sign-req both kubernetes

