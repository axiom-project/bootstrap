#!/bin/bash
set -e

KUBERNETES_VERSION=${KUBERNETES_VERSION:-$(make print-KUBERNETES_VERSION)}

docker run -d -it \
	--net=host \
	--pid=host \
	--privileged \
	--restart="unless-stopped" \
	--name merritt-kubelet \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /etc/kubernetes:/etc/kubernetes \
	merritt/merritt-kubelet \
	kubelet \
		--allow-privileged \
		--fail-swap-on=false

docker run -d -it \
	--net=host \
	--name merritt-kubeadm \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /etc/kubernetes:/etc/kubernetes \
	merritt/merritt-kubeadm \
	kubeadm init \
		--kubernetes-version=${KUBERNETES_VERSION} \
		--skip-preflight-checks



