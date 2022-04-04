

NAMESPACE=argocd
TYPE=namespace
INSTANCE=argocd

kubectl patch $TYPE/$INSTANCE -n $NAMESPACE --type json --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]'