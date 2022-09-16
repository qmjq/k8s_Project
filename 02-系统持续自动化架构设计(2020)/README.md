			k8s小包系统jenkins+gitlab+harbor持续自动化架构设计
			

		注意：都是按gitea代码仓库的项目名，创建的ci/cd架构设计的。
		文件说明：
			sjzy-packet-ingress.yaml:	kubernetes 最前 ingress-nginx配置
			sjzy-packet-front.yaml: 	前端deployment、service文件，按项目名创建deployment、service。
			sjzy-packet-dotnet.yaml: 	后端deployment、service文件，按项目名创建deployment、service。
		
			
			目录dotnet_front_config：  为前端、后端各个项目deployment 、service配置文件。
				配置文件包括：
					1、k8s项目初始是基础镜像dockerfile, 及jenkins+gitlab+harbor自动化构建部署时，pod需要的镜像dockerfile。
					2、jenkins+gitlab+harbor自动化构建部署时，生成新镜像时，需要的程序配置文件(“基于保密内容已经清空”)
			
			
			目录jenkins：		为前端、后端各个项目pipeline 配置文件。

		CI/CD原理：
			1、gitea 各项目名,代码提交自动触发webhook。
			2、jenkins收到webhook,调用相应项目名对应jenkins任务。
			3、jenkins pipeline任务pull gitlab仓库相应项目名代码, pull gitlab仓库config库的配置文件。
			4、jenkins pipeline任务执行相应构建（如:编译前后端代码、上传镜像到harbor）。
			5、jenkins pipeline任务执行kubectl发布相应项目。
	
	       实现功能：测试和 UAT 环境架构全部实现
			1. 支持存储编排
			2. 支持deployment回滚升级
			3. 故障自我修复
			4. 服务发现和负载均衡
			5. 支持配置管理
			6. 支持多种发布: k8s镜像发布,和 传统代码编译发布。
			7. 支持多种还原回滚发布：基于k8s镜像回滚 和 传统基于git分支、tag、commit id 等一键回滚发布

			k8s 的 ingress,deploy ,svc,pods, 都是按 gitea 各项目名生成
			
