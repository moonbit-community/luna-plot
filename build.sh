#moon build --target native
terminal_width=$(tput cols)
# 检查是否成功获取宽度
if [ -z "$terminal_width" ]; then
    terminal_width=80  # 如果获取失败，使用默认宽度
fi
args="$terminal_width"
./target/native/release/build/main/main.exe $args