#!/bin/sh

# This script will boostrap the cluster by installing argocd with the help of helm-overdrive.
# I am to lazy and forgetfull to remember the command.
[ "$#" -eq 1 ] || (echo "Requires a service folder" >&2 && exit 1)

export HO_APPLICATION_FOLDER=services/argocd 
export HO_ENV_FOLDER=$2
export HELM_NAMESPACE=$(cat base/services/argocd/app.yaml | yq .namespace)

helm-overdrive template \
    -c helm-overdrive.yaml \
    --helm_repo $(cat base/services/argocd/app.yaml | yq .source.helm_repo) \
    --chart_name $(cat base/services/argocd/app.yaml | yq .source.chart_name) \
    --chart_version $(cat base/services/argocd/app.yaml | yq .source.chart_version) \
    --app_name $(cat base/services/argocd/app.yaml | yq .name) \
    | kubectl apply -n $HELM_NAMESPACE -f -
