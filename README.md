# devopsdays-kz-2024
DevOps Days (KZ) 2024

1. Add library chart
```bash
git checkout main
git pull --rebase
git checkout -b feature/add-library-chart
git add .github/actions .github/workflows/test-library.yaml .github/workflows/release-library-chart.yaml tests charts/.gitignore charts/demo-library/
git commit -m 'added library chart'
git push
```
2. Add sample application
```bash
git checkout main
git pull --rebase
git checkout -b feature/add-application-1
cd charts/demo-application-1
helm dependency update
cd -
git add .github/workflows charts/demo-application-1
git commit -m 'added application 1'
git push
git checkout main
```

3. Apply ArgoCD
```bash
git checkout main
git pull --rebase
git checkout -b feature/add-argo-cd
git add argo
git commit -m 'added argo'
git push
git checkout main
# Merge PR
kind create cluster --name devopsdays --config tests/kind.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
helm upgrade --install argocd -n argo --create-namespace oci://ghcr.io/argoproj/argo-helm/argo-cd --values argo/install/values.yaml
kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
k apply -f argo
k get pods -n development
k get pods -n staging
```
4. Add jenkins
```bash
git checkout main
git pull --rebase
git checkout -b feature/add-jenkins
cd charts/demo-app-jenkins/
helm dependency update
cd -
git add charts/demo-app-jenkins
git commit -m 'added jenkins'
git push
git checkout main
```
