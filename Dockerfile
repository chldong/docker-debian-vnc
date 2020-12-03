FROM debian:latest
LABEL maintainer "cuihailiang@gmail.com"

ENV PASSWD saitron
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list
RUN sed -i "s@http://security.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list

RUN apt-get update -q && \
    apt-get install -y --no-install-recommends tzdata

RUN dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get update -q && \
    apt-get install -y --fix-missing vim mate-desktop-environment-core && \
    apt-get install -y --fix-missing firefox-esr locales ttf-wqy-zenhei ttf-wqy-microhei && \
    apt-get install -y --fix-missing tightvncserver && \
    apt-get install -y --fix-missing xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/

RUN mkdir -p /root/.vnc
RUN touch /root/.vnc/passwd
RUN chmod 400 /root/.vnc/passwd
RUN chmod go-rwx /root/.vnc
RUN touch /root/.Xresources
COPY start-vncserver.sh /root/
RUN chmod a+x /root/start-vncserver.sh

RUN echo "sbox" > /etc/hostname
RUN echo "127.0.0.1	localhost" > /etc/hosts
RUN echo "127.0.0.1	sbox" >> /etc/hosts

EXPOSE 5901
ENV USER root
CMD [ "/root/start-vncserver.sh" ]
