#!/bin/sh

# This script will boostrap the cluster by installing argocd with the help of helm-overdrive.
# I am to lazy and forgetfull to remember the command.
export HELM_NAMESPACE=argocd
export HO_APPLICATION_FOLDER=services/argocd
export HO_HELM_REPO=https://argoproj.github.io/argo-helm
export HO_CHART_NAME=argo-cd
export HO_CHART_VERSION=4.4.0

helm-overdrive template \
    -c helm-overdrive.yaml \
    --helm_repo https://argoproj.github.io/argo-helm \
    --app_name argocd \
    | kubectl apply -n $HELM_NAMESPACE -f -
