extends Node

# The URL we will connect to
export var websocket_url = "ws://127.0.0.1:8001"

# Our WebSocketClient instance
var _client = WebSocketClient.new()
var rng = RandomNumberGenerator.new()
var id = 2;
func _ready():
	
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	print(_client.connect_to_url(websocket_url))
		# Create a timer node
		
	var timer = Timer.new()

	# Set timer interval	
	timer.set_wait_time(2)

	# Set it as repeat
	timer.set_one_shot(false)

	# Connect its timeout signal to the function you want to repeat
	timer.connect("timeout", self, "repeat_me")

	# Add to the tree as child of the current node
	add_child(timer)

	timer.start()

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.

func repeat_me():

	print('loop')
	_client.get_peer(1).put_packet(JSON.print({"id": id, "positionX": get_node("Player").position.x, "positionY": get_node("Player").position.y }).to_utf8())
	
func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var data = (JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).get_result())
	print(data)
	if data != null:
		print(data.id)
		if data.id != id:
			get_node("Heleena").position.x = data.positionX
			get_node("Heleena").position.y = data.positionY
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
