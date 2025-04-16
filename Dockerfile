FROM ruby:alpine3.21

# build-base is needed for treesitter, ripgrep is needed for live_grep within telescope
RUN apk --update add \
      neovim \
      neovim-doc \
      nodejs \
      npm \
      git \
      build-base \
      ripgrep \
      gnupg \
      gawk \
      openssh \
      pass \
      tmux \
      zsh

RUN git clone https://github.com/sobolevn/git-secret.git git-secret && cd git-secret && make build && PREFIX="/usr/local" make install

WORKDIR /usr/src/dotfiles

COPY Gemfile .

RUN bundle install

CMD ["tail", "-f", "/dev/null"]
