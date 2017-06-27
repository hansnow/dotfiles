# 常用软件配置

### tmux

* 如果有正在运行的tmux server而导致tmux配置无法即时生效的话
  ``` bash
  # in tmux
  :source-file ~/.tmux.conf
  # in shell
  tmux source-file ~/.tmux.conf
  ```