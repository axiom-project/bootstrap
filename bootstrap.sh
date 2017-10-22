#!/bin/bash
set -e

APP=${APP:-$(make print-APP)}
REPO=${REPO:-$(make print-REPO)}
KUBERNETES_VERSION=${KUBERNETES_VERSION:-$(make print-KUBERNETES_VERSION)}

docker volume create etc-kubernetes
docker volume create var-lib-kubelet

docker run -d -it \
	--net=host \
	--pid=host \
	--privileged \
	--restart="unless-stopped" \
	--name ${APP}-kubelet \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /var/lib/docker:/var/lib/docker \
	-v etc-kubernetes:/etc/kubernetes \
	-v var-lib-kubelet:/var/lib/kubelet \
	-v /sys:/sys \
	${REPO}-kubelet \
	kubelet \
		--allow-privileged \
		--fail-swap-on=false

docker run -d -it \
	--net=host \
	--name ${APP}-kubeadm \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v etc-kubernetes:/etc/kubernetes \
	${REPO}-kubeadm \
	kubeadm init \
		--kubernetes-version=${KUBERNETES_VERSION} \
		--skip-preflight-checks



