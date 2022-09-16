Kubernetes ,in my work, write by myself. used in public cloud (阿里ACK、腾讯TKE、微软AKS、亚马逊EKS) .

微软云aks的uat环境部分yml,及逻辑架构图。 


创建k8s资源：

	kubectl create  -f azure-file-sc.yaml
	kubectl create  -f azure-file-pvc.yaml
	
	kubectl create  -f c_k8s_uat.yml ;
	kubectl create  -f php_k8s_uat.yml ;  
	kubectl create  -f php_k8s_uat.yml
	
获取资源状态(支持执行 kubectl api-resources 命令的显示的资源状态信息)：

	kubectl get deployments ; 或 kubectl get deployments -o wide
	kubectl get service ; 或 kubectl get service -o wide
	kubectl get pods ； 或 kubectl get pods -o wide
	
弹性伸缩手动：

	kubectl scale --replicas=1 -f php_k8s_uat.yml (所有); 
 	kubectl scale --current-replicas=1 --replicas=3 deployment/ngx-phpswoole （单个服务） ;
	kubectl scale --replicas=3 deployment/ngx-phpswoole deployment/ngx-phpapi（多个服务）
	
弹性伸缩自动：

	kubectl autoscale deployment apush --max=5 --cpu-percent=80
 
镜像滚动更新：

	更新镜像：kubectl set image deployment/cm cm=prek8s.azurecr.io/cm:v4
	回滚到上一个版本：kubectl rollout undo deployment/cm
	

QQ 858080796

http://qmjq.github.io
