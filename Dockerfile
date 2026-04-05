# 换成阿里云国内镜像，秒拉取！
FROM registry.cn-hangzhou.aliyuncs.com/larkjava/openjdk:21-jdk-slim

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
