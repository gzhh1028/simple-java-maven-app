# 阿里云官方镜像源 —— 国内最快、最稳定
FROM registry.aliyuncs.com/eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
