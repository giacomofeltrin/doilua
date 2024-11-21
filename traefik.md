microk8s helm repo add traefik https://traefik.github.io/charts
microk8s helm repo update
microk8s kubectl create namespace traefik

vim chart-traefik.yaml

```
namespaceOverride: traefik

# Deployment configuration
deployment:
  enabled: true
  replicas: 1
  kind: Deployment

# Ingress Class configuration
ingressClass:
  enabled: true
  isDefaultClass: true

# Providers configuration
providers:
  kubernetesIngress:
    enabled: true
    ingressEndpoint:
      useDefaultPublishedService: true
  kubernetesCRD:
    enabled: true

# Ports configuration
ports:
  web:
    port: 8000
    expose:
      default: true
    exposedPort: 80
    protocol: TCP
    redirectTo:
      name: websecure  # Correct format: redirect HTTP to HTTPS
      port: "443"      # Port must be quoted as a string
  websecure:
    port: 8443
    expose:
      default: true
    exposedPort: 443
    protocol: TCP
    tls:
      enabled: true  # Enable TLS for HTTPS

# Certificates resolvers configuration
certificatesResolvers:
  letsencrypt:
    acme:
      email: vitruastudio@gmail.com  # Replace with your email
      storage: /data/acme.json  # Storage for ACME data
      tlsChallenge: {}  # Enable TLS-ALPN-01 challenge for ACME

# Persistence configuration for ACME data storage
persistence:
  enabled: true
  size: 128Mi
  accessMode: ReadWriteOnce
  path: /data  # Path for storing ACME data (certificates)

# Service configuration to expose Traefik
service:
  type: LoadBalancer  # Expose as LoadBalancer (can be NodePort depending on your cloud provider)
  annotations:
    external-dns.alpha.kubernetes.io/hostname: social.vitrua.top  # Automatically create DNS record for your domain

# Resource limits for Traefik container (optional)
resources: {}




```



microk8s helm install -f chart-traefik.yaml traefik traefik/traefik --namespace traefik


