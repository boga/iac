#!/usr/bin/env sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml
kubectl patch deployment ingress-nginx-controller -n ingress-nginx --patch '{ "spec": { "template": { "spec": { "hostNetwork": true } } } } '
