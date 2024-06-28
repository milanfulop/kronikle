import 'dart:io';
import 'dart:convert';

void notifyServer(String jsonData, String category) async {
  final HttpClient _client = HttpClient();
  try {
    final request = await _client
        .postUrl(Uri.parse('http://localhost:8080/windowClosed/todo'));
    request.headers.contentType = ContentType.json;

    final decodedData = jsonDecode(jsonData);
    if (decodedData is Map<String, dynamic>) {
      decodedData['category'] = category;
      final combinedJsonData = jsonEncode(decodedData);
      request.write(combinedJsonData);
    } else if (decodedData is List) {
      final wrappedData = {'data': decodedData, 'category': category};
      final combinedJsonData = jsonEncode(wrappedData);
      request.write(combinedJsonData);
    } else {
      throw FormatException('Expected JSON object or array');
    }

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
