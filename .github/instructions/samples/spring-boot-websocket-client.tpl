let stompClient = null;
let isConnecting = false;

function connect(serverUrl) {
  if (stompClient !== null && (isConnecting || stompClient.connected === true)) {
    return;
  }

  if (stompClient !== null && stompClient.connected !== true) {
    stompClient = null;
  }

  const socket = new SockJS(serverUrl);
  stompClient = Stomp.over(socket);
  stompClient.debug = null;
  isConnecting = true;
  socket.onclose = resetConnectionState;
  stompClient.connect({}, () => {
    isConnecting = false;
    stompClient.subscribe("/topic/messages", frame => render(JSON.parse(frame.body)));
  }, resetConnectionState);
}

function resetConnectionState() {
  stompClient = null;
  isConnecting = false;
}

function disconnect() {
  if (stompClient === null) {
    resetConnectionState();

    return;
  }

  stompClient.disconnect(resetConnectionState);
}

function send(sender, content) {
  const normalizedSender = sender.trim();
  const normalizedContent = content.trim();

  if ((stompClient === null) || (stompClient.connected !== true) || !normalizedSender || !normalizedContent) {
    return;
  }

  stompClient.send("/app/chat.send", {}, JSON.stringify({ sender: normalizedSender, content: normalizedContent }));
}

window.addEventListener("beforeunload", disconnect);