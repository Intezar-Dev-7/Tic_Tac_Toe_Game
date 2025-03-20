import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket; // The socket instance for communication with the server
  static SocketClient? _instance; // Singleton instance of the SocketClient

  // Private constructor to enforce singleton pattern
  SocketClient._internal() {
    // Initialize the socket connection
    socket = IO.io('http://yourIpAddress:portNumber', <String, dynamic>{
      'transports': ['websocket'], // Use WebSocket for communication
      'autoConnect': false, // Prevent automatic connection on instance creation
    });

    socket!.connect(); // Manually connect the socket
  }

  // Getter to return the single instance of SocketClient
  static SocketClient get instance {
    _instance ??=
        SocketClient._internal(); // Create instance if it doesn't exist
    return _instance!;
  }
}
