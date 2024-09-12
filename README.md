# devopsdays-kz-2024
DevOps Days (KZ) 2024

1. Add library chart
    - git add .github/actions .github/workflows/test-library.yaml .github/workflows/release-library-chart.yaml tests charts/.gitignore charts/demo-library/
2. Add sample application
    - cd charts/demo-application-1
    - helm dependency update
    - git add .github/workflows charts/demo-application-1
3. Apply ArgoCD
4. Add jenkins
    - cd charts/demo-app-jenkins/
    - helm dependency update
    - git add charts/demo-application-1
