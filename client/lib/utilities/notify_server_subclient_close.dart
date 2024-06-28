import 'dart:convert';
import 'dart:io';

Future<void> notifyServer(String category) async {
  final HttpClient _client = HttpClient();
  try {
    final request = await _client
        .postUrl(Uri.parse('http://localhost:8080/windowClosed/todo'));
    request.headers.contentType = ContentType.json;

    request.write(
      jsonEncode(category),
    );

    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      print('Notification sent to server.');
    } else {
      print('Error sending notification: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}
