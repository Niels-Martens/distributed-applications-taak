# ProjectChatTinyurl

SETUP:

Start 2 user nodes to start chatting.

```
iex --sname user1@localhost -S mix

iex --sname user2@localhost -S mix
```

To use the TinyURL, start this specific node and run the start_link command in that node.

```
iex --sname tinyurl@localhost -S mix

TinyURL.start_link(:foo)
```

USAGE:

Users can message other users as follows:

```
Chat.send_message(:user@localhost, message)
```

Users can chorten urls as fol
