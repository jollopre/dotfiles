FROM ruby:alpine3.21

RUN bundle config --global frozen 1

# build-base is needed for treesitter, ripgrep is needed for live_grep within telescope
RUN apk --update add \
      neovim \
      neovim-doc \
      git \
      build-base \
      ripgrep

WORKDIR /usr/src/app

CMD ["tail", "-f", "/dev/null"]
