all:
	docker build -t mynginx:local .
	docker save mynginx > myimage.tar
	microk8s ctr image import myimage.tar
	microk8s ctr images ls | grep nginx
	microk8s.kubectl create deployment nginx-test --image=docker.io/library/mynginx:local
	microk8s.kubectl scale deployment nginx-test --replicas=2
	microk8s.kubectl expose deployment nginx-test --type=NodePort --port=80 --name=nginx-service
	microk8s.kubectl get service | grep nginx

stop:
	microk8s.kubectl delete deployment nginx-test || true
	microk8s.kubectl delete service nginx-service || true
	microk8s ctr images rm docker.io/library/mynginx:local || true

token:
	microk8s.kubectl -n kube-system describe secret `microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1`
