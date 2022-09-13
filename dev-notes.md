
# Update instructions

`bundle exec jekyll serve --livereload` from project root directory.

Browse to [http://localhost:4000](http://localhost:4000)

[source](https://jekyllrb.com/docs/)

# Dev machine setup

`brew install chruby ruby-install`
`ruby-install ruby`

```
echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby ruby-3.1.2" >> ~/.zshrc # run 'chruby' to see actual version
```

Quit and relaunch Terminal
`ruby -v`
`gem install jekyll bundler`

[source](https://jekyllrb.com/docs/installation/macos/)
