FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add vim zsh tmux git sudo

RUN addgroup sudo
RUN adduser --disabled-password --shell /bin/zsh --ingroup sudo paul root
RUN echo "paul   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

USER paul
WORKDIR /home/paul
ENV HOME /home/paul

ADD . /home/paul/dotfiles
RUN touch /home/paul/.zshrc
RUN mkdir /home/paul/.vim
RUN touch /home/paul/.vim/vimrc 
RUN /home/paul/dotfiles/.bin/install.sh /home/paul/dotfiles/.git

RUN mkdir /home/paul/dotfiles_local
RUN echo "export LOCAL=original" /home/paul/.zshrc_local
WORKDIR /home/paul/dotfiles_local

RUN git init
RUN git config --local user.email "test@example.com"
RUN git config --local user.name "Test User"
RUN echo "export LOCAL=new" > .zshrc_local
RUN git add .zshrc_local
RUN git commit -m "file1"

WORKDIR /home/paul

RUN /home/paul/dotfiles/.bin/install.sh /home/paul/dotfiles_local/.git .dflgit
RUN /home/paul/dotfiles/.bin/uninstall.sh .dflgit

CMD ["/bin/zsh"]

