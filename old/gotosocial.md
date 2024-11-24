# Not working
vim gotosocial.yaml
'''

apiVersion: v1
kind: Namespace
metadata:
  name: gotosocial

---

apiVersion: v1
kind: Secret
metadata:
  name: gotosocial-config
  namespace: gotosocial
type: Opaque
data:
  database-url: c3FsaXRlOi8vZGF0YS9nb3Rvc29jaWFsLmRi
  admin-username: YWRtaW4=
  admin-password: c3VwZXJzZWNyZXRwYXNzd29yZA==

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: gotosocial
  namespace: gotosocial
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gotosocial
  template:
    metadata:
      labels:
        app: gotosocial
    spec:
      containers:
      - name: gotosocial
        image: superseriousbusiness/gotosocial:latest
        ports:
        - containerPort: 8080
        envFrom:
        - secretRef:
            name: gotosocial-config
        volumeMounts:
        - mountPath: /data
          name: data
      volumes:
      - name: data
        emptyDir: {}

---

apiVersion: v1
kind: Service
metadata:
  name: gotosocial
  namespace: gotosocial
spec:
  selector:
    app: gotosocial
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP

---


apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gotosocial
  namespace: gotosocial
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls.certresolver: letsencrypt
spec:
  rules:
  - host: social.vitrua.top
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: gotosocial
            port:
              number: 80
  tls:
  - hosts:
    - social.vitrua.top


'''


microk8s kubectl apply -f gotosocial.yaml





# working

microk8s kubectl create ns gts-test
microk8s kubectl create secret generic gts-postgresql-secret --from-literal="password=$(openssl rand -hex 32)" --from-literal="postgres-password=$(openssl rand -hex 32)" -n gts-test
microk8s helm repo add fsociety https://charts.fsociety.social
microk8s helm repo update
microk8s helm upgrade --install gotosocial fsociety/gotosocial --namespace gotosocial --create-namespace --set gotosocial.config.host='domain.tld' --set gotosocial.config.accountDomain='domain.tld'