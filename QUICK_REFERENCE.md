# 快速参考

## 🚀 安装

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
brew bundle
```

## 📝 常用命令

### 维护

```bash
dot                 # 更新所有（Homebrew + Zinit + dotfiles）
reload              # 重新加载 shell 配置
zinit update        # 更新 Zinit 插件
brew update         # 更新 Homebrew
```

### Git 快捷键

```bash
gs                  # git status
ga <file>           # git add
gc                  # git commit
gp                  # git push
gl                  # git pull
gco <branch>        # git checkout
git open            # 在浏览器打开仓库
```

### 导航

```bash
..                  # cd ..
...                 # cd ../..
z <partial>         # 智能跳转（zoxide）
```

### Node.js

```bash
fnm install 20      # 安装 Node 20
fnm use 20          # 使用 Node 20
ni                  # npm install
nr <script>         # npm run
ya                  # yarn add
```

### React Native

```bash
ios                 # 打开 iOS 模拟器
rnios               # 运行 iOS
rnandroid           # 运行 Android
metro               # 启动 Metro
pod                 # 安装 iOS 依赖
```

### Python

```bash
py                  # python3
venv                # 创建虚拟环境
activate            # 激活虚拟环境
```

### 工具增强

```bash
ls                  # eza（彩色列表）
ll                  # eza -l（详细列表）
la                  # eza -la（包含隐藏文件）
```

### 代理

```bash
proxy_on            # 启用代理
proxy_off           # 禁用代理
proxy_status        # 查看代理状态
```

## 📂 重要文件

```bash
~/.zshrc            # → ~/.dotfiles/zsh/zshrc.symlink
~/.gitconfig        # → ~/.dotfiles/git/gitconfig.symlink
~/.gitconfig.local  # 个人 git 配置（不入库）
~/.localrc          # 环境变量和密钥（不入库）
~/.npmrc            # → ~/.dotfiles/node/npmrc.symlink
~/.ssh/config       # → ~/.dotfiles/ssh/config.symlink
```

## ⚙️ 自定义

### 添加别名

编辑 `~/.dotfiles/zsh/aliases-custom.zsh`:

```bash
alias myproject='cd ~/Projects/myproject'
alias deploy='./scripts/deploy.sh'
```

### 添加环境变量

编辑 `~/.localrc`:

```bash
export GITHUB_TOKEN="your_token"
export NPM_TOKEN="your_token"
export MY_VAR="value"
```

### 添加新模块

```bash
mkdir ~/.dotfiles/newtopic
cat > ~/.dotfiles/newtopic/env.zsh << 'EOF'
export MY_TOOL_HOME="$HOME/.mytool"
export PATH="$MY_TOOL_HOME/bin:$PATH"
EOF
```

## 🔧 故障排查

### Shell 启动慢

```bash
time zsh -i -c exit     # 检查启动时间
zsh -xv 2>&1 | less     # 分析启动过程
```

### Zinit 问题

```bash
zinit delete --all      # 删除所有插件
zinit update            # 重新安装
```

### 插件不工作

```bash
source ~/.zshrc         # 重新加载配置
```

### 命令找不到

```bash
echo $PATH              # 检查 PATH
which <command>         # 查找命令位置
```

## 📚 文档

- **README.md** - 完整文档和安装指南
- **ARCHITECTURE.md** - 技术架构和设计理念
- **SENSITIVE_DATA.md** - 敏感信息管理
- **INSTALLATION_TEST.md** - 测试清单
- **MIGRATION_SUMMARY.md** - 迁移总结

## 🎯 性能指标

- **启动时间**: ~0.2s（目标 <0.3s）
- **插件数量**: 3 个
- **模块数量**: 15+ 个

## 💡 提示

1. 定期运行 `dot` 保持更新
2. 使用 `~/.localrc` 存储密钥
3. 添加新功能时创建新模块
4. 使用 `reload` 快速测试配置
5. 查看 `zinit list` 了解已安装插件

## 🔗 有用链接

- [Zinit](https://github.com/zdharma-continuum/zinit) - 插件管理器
- [holman/dotfiles](https://github.com/holman/dotfiles) - 原始灵感
- [Homebrew](https://brew.sh) - 包管理器

