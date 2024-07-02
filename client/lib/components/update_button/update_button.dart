import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateButton extends StatefulWidget {
  const UpdateButton({super.key});

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  bool _isLatestVersion = true;

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastCheckedVersion = prefs.getString('lastCheckedVersion');
    final String? lastRequestDate = prefs.getString('lastRequestDate');
    final String currentVersion = '0.2';

    final String today = DateTime.now().toIso8601String().split('T').first;

    if (lastCheckedVersion == currentVersion && lastRequestDate == today) {
      print('Version check already performed today and version unchanged');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-kronikle-2ff1e.cloudfunctions.net/checkVersion'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'clientVersion': currentVersion}),
      );

      if (response.statusCode == 200) {
        final bool isLatestVersion = jsonDecode(response.body) as bool;
        setState(() {
          _isLatestVersion = isLatestVersion;
        });

        if (isLatestVersion) {
          await prefs.setString('lastCheckedVersion', currentVersion);
        } else {
          await prefs.setString('lastCheckedVersion', currentVersion);
          await prefs.setString('lastRequestDate', today);
        }
      } else {
        print('Failed to check version: ${response.body}');
      }
    } catch (e) {
      print('Error checking version: $e');
    }
  }

  void launchURL() async {
    final Uri url = Uri.parse("https://kronikle.app");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLatestVersion
        ? SizedBox.shrink()
        : TextButton(
            onPressed: launchURL,
            child: const Text("Update available!"),
          );
  }
}
