ios pods 库
https://cocoapods.org/
查找指令
pod search Networking
遇到ios framework 引用找不到去上面看看
如果没有去删除ios的framework other linker flags删除多余引用 即可


各种ruby位置
ls /Users/linzhibin/.rbenv/versions/3.1.0/bin
可执行ruby位置
/Users/linzhibin/.rbenv/shims

切换3.2.4 可用
# 1. 确保 rbenv
brew update
brew install rbenv ruby-build
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc

# 2. 装 Ruby 3.2.4
rbenv install 3.2.4
rbenv global 3.2.4
rbenv shell 3.2.4 //一定要加这个
ruby -v
which ruby

# 3. 换源
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l

# 4. 装 cocoapods
gem install cocoapods
rbenv rehash

# 5. 验证
pod --version
which pod

3.其他version
rbenv version
ruby -v


