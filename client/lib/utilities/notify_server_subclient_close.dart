import 'dart:convert';
import 'dart:io';

Future<void> notifyServer(String category, String categoryState) async {
  final HttpClient _client = HttpClient();
  try {
    final request = await _client
        .postUrl(Uri.parse('http://localhost:8080/windowClosed/todo'));
    request.headers.contentType = ContentType.json;

    final payload = jsonEncode({
      'category': category,
      'categoryState': categoryState,
    });

    request.write(payload);

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
