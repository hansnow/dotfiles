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
- 根据`Brewfile`安装软件: (在存在`Brewfile`的目录下)`brew bundle`

### macOS defaults

本机已确认的系统偏好迁移脚本：

```bash
./macos/apply-defaults.sh
```

脚本每次执行前会先备份受影响的系统偏好域，默认位置：

```bash
~/.han-macos-defaults-backups/YYYYMMDD-HHMMSS-PID/
```

如果需要回滚，运行对应备份目录里的：

```bash
~/.han-macos-defaults-backups/YYYYMMDD-HHMMSS-PID/restore.sh
```

还原脚本会导入受影响 defaults 域的完整快照，适合出问题后尽快回滚；如果备份后又手动改了同一批系统偏好域，也会一起被恢复到备份时状态。

当前脚本覆盖：

- 键盘：按键重复速度 `InitialKeyRepeat=15`、`KeyRepeat=2`，Caps Lock 映射为 Right Control。
- 触控板：轻点点按、辅助点按、三指拖移、智能缩放/手势、自然滚动、关闭 Force Click。
- Magic Mouse：横向/纵向滚动、惯性滚动、智能缩放/左右滑动手势。
- Dock：自动隐藏。
- Finder：新窗口打开下载目录。

新机器建议顺序：

```bash
brew bundle
./macos/apply-defaults.sh
```

没有自动写入的偏好：

- Alfred、iStat Menus、Squirrel/Rime 等 App 的配置包含较多缓存、窗口位置或账号状态，建议用各自的同步/导出机制迁移。
- 系统输入法列表当前包含 ABC、系统简体中文双拼、Squirrel/Rime 历史记录；这部分脚本化容易和新机器系统版本、已安装输入法冲突，先不自动写入。
- 本机没有发现独立的 `com.apple.mouse.scaling` 鼠标速度值；目前只迁移了触控板速度 `com.apple.trackpad.scaling=1` 和 Magic Mouse 手势。
- 菜单栏紧凑间距由 Bartender 实现，不直接写 `NSStatusItemSpacing` / `NSStatusItemSelectionPadding`。
- Dock 常驻 App 确实做过精简，但还没有固化最终列表；在确认具体 Dock 布局前，不自动清空或重写 `persistent-apps`。
- Rectangle 等第三方软件配置后续统一补充，目前不自动迁移。
