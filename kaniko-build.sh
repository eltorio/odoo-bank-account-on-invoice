#!/bin/bash
# Tiltfile looks like:

echo "NAMESPACE=$NAMESPACE MODULEPATH=$MODULEPATH MODULENAME=$MODULENAME"
KANIKO_POD=$(kubectl -n $NAMESPACE get pods | grep "kaniko" | cut -d' ' -f1)
BAD_RANDOM=$(echo $RANDOM-$RANDOM-$RANDOM-$RANDOM | openssl dgst -sha1 -r | awk '{print $1}' | tr -d '\n' )
kubectl create namespace $NAMESPACE
#kubectl create -n $NAMESPACE secret generic ssh-key-secret --from-file=ssh-privatekey=$HOME/.ssh/id_ecdsa --from-file=ssh-publickey=$HOME/.ssh/id_ecdsa.pub --from-literal=ssh-key-type=ecdsa
echo "CURRENT KANIKO POD is kaniko-$BAD_RANDOM"
kubectl -n $NAMESPACE delete pod --wait=false $KANIKO_POD 2>/dev/null
tar -cv --exclude "node_modules" --exclude "dkim.rsa" --exclude "private" --exclude "k8s" --exclude ".git" --exclude ".github" --exclude-vcs --exclude ".docker" --exclude "_sensitive_datas" -f - \
  ./Dockerfile odoo.conf.tpl $MODULEPATH | gzip -9 | kubectl run -n $NAMESPACE kaniko-$BAD_RANDOM \
  --rm --stdin=true \
  --image=highcanfly/kaniko:latest --restart=Never \
  --overrides='{
  "apiVersion": "v1",
  "spec": {
    "containers": [
      {
        "name": "kaniko",
        "image": "gcr.io/kaniko-project/executor:latest",
        "imagePullPolicy": "Always",
        "stdin": true,
        "stdinOnce": true,
        "args": [
          "-v","info",
          "--build-arg=MODULE_NAME='$MODULENAME'",
          "--dockerfile=Dockerfile'$EXT'",
          "--context=tar://stdin",
          "--skip-tls-verify",
          "--destination='$EXPECTED_REF'",
          "--image-fs-extract-retry=3",
          "--push-retry=3",
          "--cache=true",
          "--cache-ttl=24h",
          "--cache-repo='$DOCKER_CACHE_REGISTRY'"
        ]
      }
    ],
    "restartPolicy": "Never"
  }
}'

#kubectl delete -n $NAMESPACE secret/registry-credentials
