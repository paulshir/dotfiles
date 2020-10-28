FROM dftbase:latest

# Import and install dotfiles
ADD . /home/paul/dotfiles
RUN $DIR/dotfiles/.dotfiles/install.sh $DIR/dotfiles/.git

# Create dotfiles_local
RUN mkdir $DIR/dotfiles_local
WORKDIR /home/paul/dotfiles_local
RUN git init
RUN git config --local user.email "test@example.com"
RUN git config --local user.name "Test User"
RUN echo "export LOCAL=new" > .zshrc_local
RUN git add .zshrc_local
RUN git commit -m "file1"

# Restore WORKDIR
WORKDIR /home/paul

# Install dotfiles_local
RUN $DIR/dotfiles/.dotfiles/install.sh $DIR/dotfiles_local/.git .dflgit

# Unsintsall dotfiles_local
RUN $DIR/dotfiles/.dotfiles/uninstall.sh .dflgit

CMD ["/bin/zsh"]

