# 常用软件配置

### tmux

- 如果有正在运行的 tmux server 而导致 tmux 配置无法即时生效的话
  ```bash
  # in tmux
  :source-file ~/.tmux.conf
  # in shell
  tmux source-file ~/.tmux.conf
  ```

### brew/cask/mas

- 生成`Brewfile`: `brew bundle dump`
- 根据`Brwefile`安装软件: (在存在`Brewfile`的目录下)`brew bundle`
