all:
	docker build -f Dockerfile.nginx -t mynginx:local .
	docker build -f Dockerfile.nodejs -t express:local .
	docker save mynginx > mynginx.tar
	docker save express > express.tar
	microk8s ctr image import mynginx.tar
	microk8s ctr image import express.tar
	microk8s.kubectl apply -f nginx-service.yaml -f nginx-deployment.yaml -f nginx-ingress.yaml
	microk8s.kubectl get service | grep nginx
	microk8s.kubectl get ingress

stop:
	microk8s.kubectl delete deployment my-nginx || true
	microk8s.kubectl delete service nginx-svc || true
	microk8s.kubectl delete ingress nginx-ingress || true
	microk8s ctr images rm docker.io/library/mynginx:local || true
	microk8s ctr images rm docker.io/library/express:local || true

token:
	microk8s.kubectl -n kube-system describe secret `microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1`
