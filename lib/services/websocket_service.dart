// ignore: unused_import
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  String _status = 'Disconnected';
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _messages = [];
  String _clientId = '';

  // GANTI IP INI SESUAI LAPTOP LU!
  static const String _serverIp = '192.168.1.5'; // ← GANTI INI!
  static const int _serverPort = 3000;

  bool get isConnected => _isConnected;
  String get status => _status;
  List<Map<String, dynamic>> get messages => _messages;
  String get clientId => _clientId;

  void connect() {
    try {
      final wsUrl = 'ws://$_serverIp:$_serverPort';
      debugPrint('🔌 Connecting to $wsUrl...');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          _messages.add(data);
          
          if (data['event'] == 'connected') {
            _clientId = data['clientId'] ?? '';
            _isConnected = true;
            _status = 'Connected (ID: $_clientId)';
          }
          
          notifyListeners();
          debugPrint('📨 WebSocket: $data');
        },
        onError: (error) {
          _isConnected = false;
          _status = 'Error: $error';
          notifyListeners();
          debugPrint('❌ WebSocket error: $error');
        },
        onDone: () {
          _isConnected = false;
          _status = 'Disconnected';
          notifyListeners();
          debugPrint('🔌 WebSocket closed');
        },
      );

    } catch (e) {
      _status = 'Failed: $e';
      notifyListeners();
      debugPrint('❌ Connect failed: $e');
    }
  }

  void send(String message) {
    if (_isConnected) {
      _channel?.sink.add(jsonEncode({
        'type': 'chat',
        'message': message,
        'from': _clientId,
        'timestamp': DateTime.now().toIso8601String(),
      }));
      debugPrint('📤 Sent: $message');
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    _status = 'Disconnected';
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}