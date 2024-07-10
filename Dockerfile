FROM ubuntu:20.04

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    && rm -rf /var/lib/apt/lists/*

# LibreOffice PPA 추가 및 설치
RUN add-apt-repository ppa:libreoffice/ppa && \
    apt-get update && \
    apt-get install -y libreoffice libreoffice-java-common

# H2Orestart 확장 설치
COPY H2Orestart-0.6.6.oxt /tmp/H2Orestart-0.6.6.oxt

# LibreOffice를 헤드리스 모드로 실행하고 확장을 추가
RUN libreoffice --headless --norestore --nofirststartwizard --accept="socket,host=localhost,port=2002;urp;" --nodefault --nologo & \
    sleep 10 && \
    unopkg add --shared /tmp/H2Orestart-0.6.6.oxt && \
    pkill -f soffice

# 컨테이너 유지
CMD ["tail", "-f", "/dev/null"]
