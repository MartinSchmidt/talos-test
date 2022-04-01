
BASE_FOLDER=$(cat helm-overdrive.yaml | yq .base_folder)
FILES=$(grep -lr "apiVersion: argocd-discover/v1alpha1" ./$BASE_FOLDER)

rm -f manifest.yaml

for f in $FILES
do 
    NAME=$(cat $f | yq .name)
    NAMESPACE=$(cat $f | yq .namespace)
    PROJECT=$(cat $f | yq .project)
    HELM_REPO=$(cat $f | yq .source.helm_repo)
    CHART_NAME=$(cat $f | yq .source.chart_name)
    CHART_VERSION=$(cat $f | yq .source.chart_version)

    echo "$NAME $PROJECT $CHART_NAME $CHART_VERSION"

cat << EndOfMessage >> manifest.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $NAME
  namespace: $ARGOCD_APP_NAMESPACE
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: $PROJECT
  destination:
    server: https://kubernetes.default.svc
    namespace: $NAMESPACE
  syncPolicy:
    automated:
    prune: true
    selfHeal: true
    allowEmpty: false 
  source:
    repoURL: $ARGOCD_APP_SOURCE_REPO_URL
    targetRevision: $ARGOCD_APP_SOURCE_TARGET_REVISION
    path: $ARGOCD_APP_SOURCE_PATH
    plugin:
    name: helm-overdrive
    env:
    - name: HO_APPLICATION_FOLDER
      value: services/argocd
    - name: HO_HELM_REPO
      value: $HELM_REPO
    - name: HO_CHART_NAME
      value: $CHART_NAME
    - name: HO_CHART_VERSION
      value: $CHART_VERSION
---
EndOfMessage

done

cat manifest.yaml