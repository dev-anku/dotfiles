# timer() {
#     secs=$1
#   while [ $secs -gt 0 ]; do
#     clear
#     printf "\e[1;37mTimer: %02d:%02d\e[0m\r" $((secs / 60)) $((secs % 60))
#     sleep 1
#     : $((secs--))
#   done
#   echo -e "\n\e[1;32mTime's up!\e[0m"
# }

secs=600
TMPFILE="/tmp/waybar-timer.json"
while [ $secs -gt 0 ]; do
  printf '{"text":"  %02d:%02d"}\n' $((secs / 60)) $((secs % 60)) > "$TMPFILE"
  sleep 1
  ((secs--))
done
echo '{"text":"  "}' > "$TMPFILE"
