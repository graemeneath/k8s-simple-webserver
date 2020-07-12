all:
	docker build -f Dockerfile.nginx -t mynginx:local .
	docker build -f Dockerfile.nodejs -t express:local .
	docker save mynginx > mynginx.tar
	docker save express > express.tar
	microk8s ctr image import mynginx.tar
	microk8s ctr image import express.tar
	microk8s.kubectl apply -f info-service.yaml -f nginx-service.yaml -f nginx-deployment.yaml -f nginx-ingress.yaml -f info-ingress.yaml
	microk8s.kubectl get service nginx-svc
	microk8s.kubectl get service info-svc
	microk8s.kubectl get ingress

stop:
	microk8s.kubectl delete deployment nginx-deployment || true
	microk8s.kubectl delete service info-svc || true
	microk8s.kubectl delete service nginx-svc || true
	microk8s.kubectl delete ingress nginx-ingress || true
	microk8s ctr images rm docker.io/library/mynginx:local || true
	microk8s ctr images rm docker.io/library/express:local || true

token:
	microk8s.kubectl -n kube-system describe secret `microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1`

local: localstop
	docker build -f Dockerfile.nodejs-local -t express:local .
	docker run -d --name express_local -p 3000:3000 express:local

localstop:
	docker stop express_local || true
	docker rm express_local || true
