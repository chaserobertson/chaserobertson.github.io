#!/bin/zsh

brew install chruby ruby-install

if [[ ! -d "~/.rubies/ruby-3.1.2" ]]; then
    printf "Installing ruby\n"
    ruby-install --no-reinstall --cleanup --jobs=8 ruby-3.1.2
    source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
    chruby ruby-3.1.2

    echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
    echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
    echo "chruby ruby-3.1.2" >> ~/.zshrc
fi

if [[ $(ruby -v) =~ universal ]]; then 
    echo "Ruby install failed"
else
    gem install jekyll bundler
    bundle install
    bundle exec jekyll serve --livereload
fi
