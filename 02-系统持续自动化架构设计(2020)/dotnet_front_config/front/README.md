	*****小包系统 *******
	     前端配置
	注意: 文件夹 packet 是k8s前端业务基础镜像
	
	dockerfile: 	jenkins 自动 或手动 创建前端项目对应镜像时dockerfile文件
		    	“from harbor:80/front/packet”，是基于的基础nginx镜像（通过packet文件的dockerfile创建的）。
	全部conf文件：	是对应前端项目名的nginx配置文件（其实都是一样的，是为了统一管理、标准化、自动化）。
	
