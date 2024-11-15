#!/bin/bash

session_name=$1
path="/nfs/home/zekai.liang/workspace/nrsim-dl"

tmux has-session -t "$session_name" 2>/dev/null

if [ $? != 0 ]; then
    # Create the session if it doesn't exist
    tmux new-session -d -s "$session_name" -c "$path"

    # Customize the layout
    tmux split-window -h -t "$session_name:0" -c "$path"     # Split pane horizontally
    tmux split-window -v -t "$session_name:0.1" -c "$path"   # Spplit right panel vertically, 0.1 is window.pane

    # Change the first pane to 70% width
    total_width=$(tmux display -p -F "#{window_width}")
    target_width=$((total_width * 80 / 100))
    tmux resize-pane -t "$session_name:0.0" -x "$target_width"

    tmux select-pane -t "$session_name:0.0"
    tmux send-keys -t "$session_name:0.0" 'vim ~/workspace/nrsim-dl/Network/UE/ModemUE/ChannelEstimator/ChannelEstimatorCrs.cpp' C-m
    tmux send-keys -t "$session_name:0.2" 'vim ~/opt/runNrsim/launch.gdb' C-m
fi

# Attach to the session
tmux attach-session -t "$session_name"
