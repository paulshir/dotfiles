FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add vim zsh tmux git sudo

RUN addgroup sudo
RUN adduser --disabled-password --shell /bin/zsh --ingroup sudo paul root
RUN echo "paul   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

USER paul
ENV HOME /home/paul
ENV DIR /home/paul
WORKDIR /home/paul

# Setup original files to be overridden
RUN echo source $DIR/.zshrc_local > $DIR/.zshrc 
RUN mkdir $DIR/.vim
RUN touch $DIR/.vim/vimrc 
RUN echo "export LOCAL=original" > $DIR/.zshrc_local

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

CMD ["/bin/zsh"]
