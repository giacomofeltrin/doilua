microk8s helm repo add traefik https://traefik.github.io/charts
microk8s helm repo update
microk8s kubectl create namespace traefik

cd 
mkdir data
cd data/
mkdir traefik
cd

vim chart-traefik.yaml

```
namespaceOverride: traefik

# Certificates resolvers configuration https://doc.traefik.io/traefik/https/acme/#certificate-resolvers
certificatesResolvers:
  letsencrypt:
    acme:
      email: vitruastudio@gmail.com
      storage: /data/traefik/acme.json
      tlsChallenge: {}

# Persistence configuration for saving certificates
persistence:
  enabled: true
  size: 128Mi
  accessMode: ReadWriteOnce
  path: /data/traefik

# Service configuration to expose Traefik
service:
  enabled: true
  type: LoadBalancer
  annotations:
    external-dns.alpha.kubernetes.io/hostname: x.vitrua.top

# Resource limits for Traefik container
resources: {}



```



microk8s helm install -f chart-traefik.yaml traefik traefik/traefik --namespace traefik



vim ingress.yaml

```

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
  namespace: traefik
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls.certresolver: letsencrypt
spec:
  rules:
    - host: x.vitrua.top
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: example-service
                port:
                  number: 80
  tls:
    - hosts:
        - x.vitrua.top


```

microk8s kubectl apply -f ingress.yaml