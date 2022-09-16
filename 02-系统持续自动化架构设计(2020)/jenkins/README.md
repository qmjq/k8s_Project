	小包系统 jenkins's Pipeline file
	
	注意：都是按gitea代码仓库的项目名，创建的jenkins pipeline任务。
		
		目录dotnet: 	保存为后端各个任务pipeline。
		目录front:	保存为前端各个任务pipeline。
	
	jenkins实现方法：
		实现方法（前后端一样啊）：
			正常发布:
			Jenkins读取发布参数IMPLEMENT（默认deploy）---分支参数BRANCH---- pipeline读取git代码 ---- copy config(git实现的啊，由于目前没有类似微服务配置中心)----编译（pnpm/dotnet）---- build docker----上传harbor---update k8s
		
	 		传统回滚发布:
			Jenkins读取默认发布参数IMPLEMENT（git_rollback）----分支TAG参数 TAG---- pipeline读取git代码 ---- copy config(git实现的啊，由于目前没有类似微服务配置中心)----编译（pnpm/dotnet）---- build docker----上传harbor ---update k8s
			K8s回滚发布（回滚比传统快很多）：
			Jenkins读取默认发布参数IMPLEMENT（k8s_rollback）--- 镜像标签IMAGE_TAG----拉取harbor镜像---- update k8s

