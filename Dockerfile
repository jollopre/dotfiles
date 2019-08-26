FROM ruby:2.6.3-slim-buster

RUN apt update && apt-get install -y build-essential \
      vim-common \
      git \
      curl \
      silversearcher-ag \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && bash ~/.fzf/install

COPY ./.vimrc .
COPY ./setup.sh .

RUN bash $HOME/setup.sh
