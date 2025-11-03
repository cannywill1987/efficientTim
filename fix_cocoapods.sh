#!/bin/bash

# 修复 CocoaPods 脚本 - Fix CocoaPods Script
# 该脚本将帮助修复 CocoaPods 的权限和依赖问题

echo "======================================"
echo "开始修复 CocoaPods 环境..."
echo "Starting to fix CocoaPods environment..."
echo "======================================"

# 1. 修复 gem 目录权限
echo "\n步骤 1: 修复 gem 目录权限..."
echo "Step 1: Fixing gem directory permissions..."
chmod -R u+w ~/.rbenv/versions/3.0.2/lib/ruby/gems/3.0.0/ 2>/dev/null

# 2. 完全删除所有 CocoaPods 相关的 gems
echo "\n步骤 2: 卸载所有 CocoaPods 相关的 gems..."
echo "Step 2: Uninstalling all CocoaPods related gems..."
rm -rf ~/.rbenv/versions/3.0.2/lib/ruby/gems/3.0.0/gems/cocoapods-* 2>/dev/null
rm -rf ~/.rbenv/versions/3.0.2/lib/ruby/gems/3.0.0/specifications/cocoapods-* 2>/dev/null

# 3. 清理 gem 缓存
echo "\n步骤 3: 清理 gem 缓存..."
echo "Step 3: Cleaning gem cache..."
rm -rf ~/.rbenv/versions/3.0.2/lib/ruby/gems/3.0.0/cache/cocoapods-* 2>/dev/null

# 4. 安装必需的依赖
echo "\n步骤 4: 安装必需的依赖..."
echo "Step 4: Installing required dependencies..."
gem install logger --no-document
gem install activesupport -v 7.0.0 --no-document

# 5. 重新安装 CocoaPods
echo "\n步骤 5: 重新安装 CocoaPods..."
echo "Step 5: Reinstalling CocoaPods..."
gem install cocoapods --no-document

# 6. 更新 rbenv shims
echo "\n步骤 6: 更新 rbenv shims..."
echo "Step 6: Updating rbenv shims..."
rbenv rehash

# 7. 验证安装
echo "\n步骤 7: 验证 CocoaPods 安装..."
echo "Step 7: Verifying CocoaPods installation..."
pod --version

if [ $? -eq 0 ]; then
    echo "\n======================================"
    echo "✅ CocoaPods 修复成功！"
    echo "✅ CocoaPods fixed successfully!"
    echo "======================================"
    
    echo "\n现在您可以运行以下命令来安装依赖:"
    echo "Now you can run the following commands to install dependencies:"
    echo ""
    echo "  cd ios && pod install"
    echo "  cd macos && pod install"
    echo ""
else
    echo "\n======================================"
    echo "❌ CocoaPods 修复失败"
    echo "❌ CocoaPods fix failed"
    echo "======================================"
    echo "\n请尝试以下手动步骤:"
    echo "Please try the following manual steps:"
    echo ""
    echo "1. 更新 Homebrew 并安装最新的 Ruby:"
    echo "   brew install ruby"
    echo ""
    echo "2. 使用系统 Ruby 安装 CocoaPods:"
    echo "   sudo gem install cocoapods"
    echo ""
    echo "3. 或者使用 Homebrew 安装 CocoaPods:"
    echo "   brew install cocoapods"
    echo ""
fi



