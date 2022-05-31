FROM debian:bookworm

ENV DEBIAN_FRONTEND="noninteractive"

SHELL ["/bin/bash", "-o", "allexport", "-c"]

ENV HOME=/root
ENV ZSH_CUSTOM_COMPLETIONS_DIR=/usr/local/share/zsh/completions
ENV PATH_USR_LOCAL_BIN=/usr/local/bin

WORKDIR ${HOME}

RUN mkdir -p ./build

ADD ./build/step1 ./build
RUN ./build/*.sh && rm -rf ./build/*

ADD ./build/step2 ./build
RUN ./build/*.sh && rm -rf ./build/*

ADD ./build/step3 ./build
RUN ./build/*.sh && rm -rf ./build/*

ADD ./build/step4 ./build
RUN ./build/*.sh && rm -rf ./build/*

ADD ./build/step5 ./build
RUN ./build/*.sh && rm -rf ./build/*

ADD ./build/step6/copy ./build/copy
RUN cp -ar ./build/copy/. /
ADD ./build/step6/*.sh ./build
RUN ./build/*.sh && rm -rf ./build/*

RUN systemctl enable mongodb.service
RUN systemctl enable ttyd.service
RUN systemctl enable run-autostart.service

ADD ./build/step7 ./build
RUN ./build/*.sh && rm -rf ./build/*

ADD ./build/step8 ./build
RUN ls -lah ./build/*.sh && ./build/*.sh && rm -rf ./build/*

RUN mandb

# https://www.freedesktop.org/wiki/Software/systemd/ContainerInterface/
# To allow systemd (and other code) to identify that it is executed within a container
ENV container docker

# A different stop signal is required, so systemd will initiate a shutdown when
# running 'docker stop <container>'.
STOPSIGNAL SIGRTMIN+3

# RUN rm -rf /etc/systemd/system/multi-user.target.wants/*.service
# RUN ls -lah /etc/systemd/system/multi-user.target.wants

# As this image should run systemd, the default command will be changed to start
# the init system. CMD will be preferred in favor of ENTRYPOINT, so one may
# override it when creating the container to e.g. to run a bash console instead.
# CMD [ "/sbin/init" ]
CMD [ "/sbin/init" ]
