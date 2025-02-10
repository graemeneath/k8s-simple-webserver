nginx: stop
	microk8s enable ingress
	microk8s.kubectl delete secret tls-secret || true
	sudo microk8s.kubectl create secret tls tls-secret --cert=/etc/letsencrypt/live/infinitytek.xyz/fullchain.pem --key=/etc/letsencrypt/live/infinitytek.xyz/privkey.pem -n default
	docker build -t mynginx:local .
	docker save mynginx > /tmp/mynginx.tar
	microk8s ctr image import /tmp/mynginx.tar
	microk8s.kubectl apply -f nginx-deployment.yaml
	microk8s.kubectl apply -f nginx-service.yaml
	microk8s.kubectl apply -f nginx-ingress.yaml
	microk8s.kubectl get service nginx-svc
	microk8s.kubectl get ingress
	microk8s.kubectl get secret tls-secret
    
stop:
	microk8s.kubectl delete deployment nginx-deployment || true
	microk8s.kubectl delete service nginx-svc || true
	microk8s.kubectl delete ingress nginx-ingress || true
	microk8s ctr images rm docker.io/library/mynginx:local || true

token:
	microk8s.kubectl -n kube-system describe secret `microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1`

local: localstop
	docker build -t nginx_local .
	docker run -d --name nginx_local -p 8080:8080 -p 8443:8443 nginx_local

localstop:
	docker stop nginx_local || true
	docker rm nginx_local || true

shell:
	microk8s.kubectl exec --stdin --tty `microk8s.kubectl get pods | grep nginx-deploy | awk '{ print $$1 }'` -- /bin/bash

shell-ingress:
	microk8s.kubectl -n ingress exec --stdin --tty `microk8s.kubectl get pods -n ingress | grep nginx | awk '{ print $$1 }'` -- /bin/bash

logs-ingress:
	microk8s.kubectl logs -f -n ingress `microk8s.kubectl get pods -n ingress | grep nginx | awk '{ print $$1 }'`

cert:
	sudo certbot certificates
	sudo certbot renew --dry-run

cert-create:
	sudo certbot certonly --webroot -w /pvc -d infinitytek.xyz
