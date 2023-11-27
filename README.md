# My Personal Website

This was created using the Chirpy Starter [![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)](https://rubygems.org/gems/jekyll-theme-chirpy) [![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[use-template]: https://github.com/cotes2020/chirpy-starter/generate
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE


## Update instructions

`bundle exec jekyll serve --livereload` from project root directory.

Browse to [http://localhost:4000](http://localhost:4000)

[source](https://jekyllrb.com/docs/)

## Dev machine setup

```
brew install chruby ruby-install
ruby-install ruby
```

```
echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby $(chruby | xargs)" >> ~/.zshrc
```

Quit and relaunch Terminal

```
ruby -v
gem install jekyll bundler`
bundle install
```

[source](https://jekyllrb.com/docs/installation/macos/)
