FROM dftbase:latest

ADD . /home/paul/dotfiles
RUN /home/paul/dotfiles/.dotfiles/install.sh /home/paul/dotfiles/.git

RUN mkdir /home/paul/dotfiles_local
WORKDIR /home/paul/dotfiles_local

RUN git init
RUN git config --local user.email "test@example.com"
RUN git config --local user.name "Test User"
RUN echo "export LOCAL=new" > .zshrc_local
RUN git add .zshrc_local
RUN git commit -m "file1"

WORKDIR /home/paul

RUN /home/paul/dotfiles/.dotfiles/install.sh /home/paul/dotfiles_local/.git .dflgit

CMD ["/bin/zsh"]

