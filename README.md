# send command to process in terminal

```
screen -X YOUR COMMAND
tmux send-keys -t server "echo 'Hello World'" ENTER
```

# Attach to session

```
screen -x
tmux attach -t server
```