pipeline {
    // 直接在 Jenkins 环境运行，不使用 Docker（解决你所有报错）
    agent any

    stages {
        // 1. 构建打包（Maven）
        stage('Build') {
            steps {
                echo '✅ 开始打包...'
                sh 'mvn clean package -Dmaven.test.skip=true'
            }
        }

        // 2. 上传文件 + 远程部署（核心）
        stage('Deploy to Server') {
            steps {
                echo '✅ 开始远程部署...'
                
                // 通过 SSH 发送文件并执行部署脚本
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'aliyun-s1', // 这里必须写你 Jenkins 里的 SSH 名称
                        transfers: [
                            sshTransfer(
                                sourceFiles: 'target/*.jar,Dockerfile', // 要上传的文件
                                remoteDirectory: 'hello-maven'           // 远程目录
                            )
                        ],
                        // 在服务器上执行的部署命令
                        execCommand: '''
                            #!/bin/bash
                            cd /home/jenkins/workspace/hello-maven
                            
                            # 停止旧容器
                            docker stop hellomaven || true
                            docker rm hellomaven || true
                            docker rmi nzc/hellomaven:1.0 || true
                            
                            # 构建并启动
                            docker build -t nzc/hellomaven:1.0 .
                            docker run -d -p 880:8080 --name hellomaven nzc/hellomaven:1.0
                            
                            echo "✅ 部署成功！访问端口：880"
                        '''
                    )
                ])
            }
        }
    }

    // 构建后输出信息
    post {
        success {
            echo '🎉 全部流程执行成功！'
        }
        failure {
            echo '❌ 构建失败！'
        }
    }
}
