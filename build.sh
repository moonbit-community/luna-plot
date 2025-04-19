moon build --target native
terminal_width=$(tput cols)
terminal_height=$(tput lines)

# 检查是否成功获取宽度和高度
if [ -z "$terminal_width" ]; then
    terminal_width=80  # 如果获取失败，使用默认宽度
fi
if [ -z "$terminal_height" ]; then
    terminal_height=24  # 如果获取失败，使用默认高度
fi

args="$terminal_width $terminal_height"
./target/native/release/build/main/main.exe $args
