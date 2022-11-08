#!/bin/bash
CSR=$1
NAME=$2
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${NAME}
spec:
  groups:
  - system:authenticated
  request: $(echo $CSR | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
  - client auth
EOF
kubectl certificate approve ${NAME}
