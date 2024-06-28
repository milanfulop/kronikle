import 'dart:convert';
import 'dart:io';

import 'package:window_manager/window_manager.dart';

void notifyServer(String jsonData) async {
  print(jsonData);
  final HttpClient _client = HttpClient();
  try {
    final request =
        await _client.postUrl(Uri.parse('http://localhost:8080/windowClosed'));
    request.headers.contentType = ContentType.json;
    request.write(jsonData);
    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      print('Notification sent to server.');
    } else {
      print('Error sending notification: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }

  windowManager.close();
}
