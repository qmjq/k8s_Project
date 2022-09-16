ARG01=$1
ARG02=$2
ARG03=$3
ARG04=$4

#curl -X POST -H "Content-Type: application/json" https://open.feishu.cn/open-apis/bot/v2/hook/1c919aa9-f31d-494c-a3de-a26ef8d5c991 -d '{"msg_type": "post","content": {"post": {"zh_cn": {"title": "jenkins打包发布通知","content": [[{"tag": "text","text": " 项目:      ${JOB_NAME} 有更新:\n "},{"tag": "text","text": "BUILD_ID:  第 $2 次构建 \n"},{"tag": "a","text": "请查看","href": "$JOB_URL"}]]}}}}'


SEND_MESSAGE(){

	JOB_NAME=$1
	BUILD_NUMBER=$2
	JOB_URL=$3

	MESSAGE=$(echo "{\"msg_type\": \"post\",\"content\": {\"post\": {\"zh_cn\": {\"title\": \"jenkins打包发布通知\",\"content\": [[{\"tag\": \"text\",\"text\": \" 项目:   $JOB_NAME 正在部署 \n \"},{\"tag\": \"text\",\"text\": \"BUILD_ID:  属于第 $BUILD_NUMBER 次构建部署  \n\"},{\"tag\": \"a\",\"text\": \"请查看\",\"href\": \"$JOB_URL\"}]]}}}}")

	curl -X POST -H "Content-Type: application/json" https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxxxx -d "$MESSAGE" && exit 0

}

SEND_MESSAGE_SUCCESS(){

	JOB_NAME=$1
	BUILD_NUMBER=$2
	JOB_URL=$3

	MESSAGE=$(echo "{\"msg_type\": \"post\",\"content\": {\"post\": {\"zh_cn\": {\"title\": \"jenkins打包发布通知\",\"content\": [[{\"tag\": \"text\",\"text\": \" 项目:   $JOB_NAME 部署成功 \n \"},{\"tag\": \"text\",\"text\": \"BUILD_ID:  属于第 $BUILD_NUMBER 次构建部署  \n\"},{\"tag\": \"a\",\"text\": \"请查看\",\"href\": \"$JOB_URL\"}]]}}}}")

	curl -X POST -H "Content-Type: application/json" https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxxxx -d "$MESSAGE" && exit 0

}

SEND_MESSAGE_FAILED(){

	JOB_NAME=$1
	BUILD_NUMBER=$2
	JOB_URL=$3

	MESSAGE=$(echo "{\"msg_type\": \"post\",\"content\": {\"post\": {\"zh_cn\": {\"title\": \"jenkins打包发布通知\",\"content\": [[{\"tag\": \"text\",\"text\": \" 项目:   $JOB_NAME 部署失败 \n \"},{\"tag\": \"text\",\"text\": \"BUILD_ID:  属于第 $BUILD_NUMBER 次构建部署  \n\"},{\"tag\": \"a\",\"text\": \"请查看\",\"href\": \"$JOB_URL\"}]]}}}}")

	curl -X POST -H "Content-Type: application/json" https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxxxx -d "$MESSAGE" && exit 0

}

main (){

	[ "$ARG01" = "SUCCESS" ] && SEND_MESSAGE_SUCCESS $ARG02 $ARG03 $ARG04;
	[ "$ARG01" = "FAILED" ] && SEND_MESSAGE_FAILED  $ARG02 $ARG03 $ARG04;
	[ "$ARG01" != "SUCCESS" ] && [  "$ARG01"  != "FAILED" ]  && SEND_MESSAGE  $ARG02 $ARG03 $ARG04;

}

main
