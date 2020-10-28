FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add vim zsh tmux git sudo perl curl ncurses findutils

RUN addgroup sudo
RUN adduser --disabled-password --shell /bin/zsh --ingroup sudo paul root
RUN echo "paul   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

USER paul
ENV HOME /home/paul
ENV DIR /home/paul
WORKDIR /home/paul