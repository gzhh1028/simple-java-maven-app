pipeline {
    agent any

    // 自动使用配置好的 Maven
    tools {
        maven 'M3'
    }

    stages {
        // 1. 打包
        stage('Build') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true'
            }
        }

        // 2. 远程部署
        stage('Deploy') {
            steps {
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'aliyun-s1', // 你的SSH服务器名称
                        transfers: [
                            sshTransfer(
                                sourceFiles: 'target/*.jar,Dockerfile',
                                remoteDirectory: 'hello-maven'
                            )
                        ],
                        execCommand: '''
                            cd /home/jenkins/workspace/hello-maven
                            docker stop hellomaven || true
                            docker rm hellomaven || true
                            docker rmi nzc/hellomaven:1.0 || true
                            docker build -t nzc/hellomaven:1.0 .
                            docker run -d -p 880:8080 --name hellomaven nzc/hellomaven:1.0
                            echo "✅ 部署成功！端口 880"
                        '''
                    )
                ])
            }
        }
    }
}
