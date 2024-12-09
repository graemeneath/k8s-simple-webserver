nginx: stop
	microk8s enable ingress
	microk8s.kubectl delete secret tls-secret || true
	microk8s.kubectl create secret tls tls-secret --cert=certs/letsencrypt/live/infinitytek.xyz/fullchain.pem --key=certs/letsencrypt/live/infinitytek.xyz/privkey.pem -n default
	docker build -t mynginx:local .
	docker save mynginx > mynginx.tar
	microk8s ctr image import mynginx.tar
	microk8s.kubectl apply -f nginx-service.yaml -f nginx-deployment.yaml -f nginx-ingress.yaml
	microk8s.kubectl get service nginx-svc
	microk8s.kubectl get ingress
	microk8s.kubectl get secret tls-secret
    
all:
	microk8s enable ingress
	microk8s.kubectl delete secret tls-secret || true
	microk8s.kubectl create secret tls tls-secret --cert=certs/letsencrypt/live/infinitytek.xyz/fullchain.pem --key=certs/letsencrypt/live/infinitytek.xyz/privkey.pem -n default
	docker build -t mynginx:local .
	docker build -f Dockerfile.nodejs -t express:local .
	docker save mynginx > mynginx.tar
	docker save express > express.tar
	microk8s ctr image import mynginx.tar
	microk8s ctr image import express.tar
	microk8s.kubectl apply -f info-service.yaml -f nginx-service.yaml -f nginx-deployment.yaml -f nginx-ingress.yaml -f info-ingress.yaml
	microk8s.kubectl get deployment
	microk8s.kubectl get service nginx-svc
	microk8s.kubectl get ingress
	microk8s.kubectl get secret tls-secret

stop:
	microk8s.kubectl delete deployment nginx-deployment || true
	microk8s.kubectl delete service nginx-svc || true
	microk8s.kubectl delete ingress nginx-ingress || true
	microk8s ctr images rm docker.io/library/mynginx:local || true
	#microk8s.kubectl delete service info-svc || true
	#microk8s.kubectl delete ingress info-ingress || true
	#microk8s ctr images rm docker.io/library/express:local || true

token:
	microk8s.kubectl -n kube-system describe secret `microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1`

local: localstop
	#docker build -f Dockerfile.nodejs-local -t express:local .
	#docker run -d --name express_local -p 3000:3000 express:local
	docker build -t nginx_local .
	docker run -d --name nginx_local -p 8080:8080 -p 8443:8443 nginx_local

localstop:
	docker stop nginx_local || true
	docker rm nginx_local || true

shell:
	microk8s.kubectl exec --stdin --tty `microk8s.kubectl get pods | grep nginx-deploy | awk '{ print $$1 }'` -- /bin/sh
