#!/bin/bash

# Become a Certificate Authority
# Generate private key
sudo openssl genrsa -des3 -out myCA.key 2048
# Generate root certificate
sudo openssl req -x509 -new -nodes -key myCA.key -sha256 -days 825 -out myCA.pem