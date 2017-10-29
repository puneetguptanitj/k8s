#install x509 type
if [ ! -d easy-rsa ]; then
    git clone https://github.com/OpenVPN/easy-rsa.git
    cp both easy-rsa/easyrsa3/x509-types/
fi

EASY_RSA=easy-rsa/easyrsa3/easyrsa

#create the certs for etcd
$EASY_RSA init-pki
$EASY_RSA build-ca nopass
$EASY_RSA --req-cn=kubernetes --req-org=kubernetes --use-algo=rsa --keysize=2048 --req-email= --dn-mode=org  --subject-alt-name=DNS:localhost,DNS:kubernetes.local,IP:127.0.0.1,IP:192.168.33.10,IP:192.168.33.11,IP:192.168.33.12 gen-req kubernetes nopass
$EASY_RSA --subject-alt-name=DNS:localhost,DNS:kubernetes.local,IP:127.0.0.1,IP:192.168.33.10,IP:192.168.33.11,IP:192.168.33.12 sign-req both kubernetes

