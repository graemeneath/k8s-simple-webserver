all:
	docker build -t mynginx:local .
	docker save mynginx > myimage.tar
	microk8s ctr image import myimage.tar
	microk8s ctr images ls | grep nginx
	microk8s.kubectl apply -f nginx-service.yaml
	microk8s.kubectl get service | grep nginx
	microk8s.kubectl get ingress

stop:
	microk8s.kubectl delete deployment my-nginx || true
	microk8s.kubectl delete service nginx-svc || true
	microk8s.kubectl delete ingress nginx-ingress || true
	microk8s ctr images rm docker.io/library/mynginx:local || true

token:
	microk8s.kubectl -n kube-system describe secret `microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1`
