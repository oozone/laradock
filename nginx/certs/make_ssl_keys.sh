#!/bin/bash

if [ -z "$*" ]; then echo "There is no domain argument"; exit 0; fi

NAME=$1
CERTS_FOLDER=$1
ROOT_CERTS_FOLDER="root_certs"
ROOT_CA="myCA2.pem"
ROOT_CA_KEY="myCA2.key"



mkdir -p ./${NAME}

## Generate private key
#openssl genrsa -des3 -out myCA.key 2048
#
## Generate root certificate
#openssl req -x509 -new -nodes -key myCA.key -sha256 -days 825 -out myCA.pem

# Generate a private key
openssl genrsa -out ./${CERTS_FOLDER}/${NAME}.key 2048

# Create a certificate-signing request
openssl req -new -key ./${CERTS_FOLDER}/${NAME}.key -out ./${CERTS_FOLDER}/${NAME}.csr

# Create a config file for the extensions
>./${CERTS_FOLDER}/${NAME}.ext cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${NAME} # Be sure to include the domain name here because Common Name is not so commonly honoured by itself
#DNS.2 = bar.${NAME} # Optionally, add additional domains (I've added a subdomain here)
EOF

# Create the signed certificate
openssl x509 -req -in ./${CERTS_FOLDER}/${NAME}.csr -CA ./${ROOT_CERTS_FOLDER}/${ROOT_CA} -CAkey ./${ROOT_CERTS_FOLDER}/${ROOT_CA_KEY} -CAcreateserial -out ./${CERTS_FOLDER}/${NAME}.crt -days 825 -sha256 -extfile ./${CERTS_FOLDER}/${NAME}.ext
