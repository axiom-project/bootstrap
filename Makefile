APP=merritt
REPO?=merritt/$(APP)
TAG?=latest

KUBERNETES_VERSION?=1.8.1
ARCH=amd64

.PHONY: all
all: kubeadm kube-proxy kubelet

.PHONY: kubeadm kube-proxy kubelet
kubeadm kube-proxy kubelet: %:
	@docker build \
		--tag $(REPO)-$* \
		--build-arg "TARGET=$*" \
		--build-arg "KUBERNETES_VERSION=${KUBERNETES_VERSION}" \
		--build-arg "ARCH=${ARCH}" \
		--file Dockerfile.kubernetes \
		.

.PHONY: print-%
print-%: ; @echo $($*)

