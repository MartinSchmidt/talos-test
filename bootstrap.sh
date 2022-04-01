#!/bin/sh

# This script will boostrap the cluster by installing argocd with the help of helm-overdrive.
# I am to lazy and forgetfull to remember the command.
./helm-overdrive template -c helm-overdrive.yaml --application_folder services/argocd --helm_repo https://argoproj.github.io/argo-helm --app_name argocd --chart_name argo-cd --chart_version 4.4.0 | kubectl apply -n argocd -f -