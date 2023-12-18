import 'dart:convert';

import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final String jsonString = await DefaultAssetBundle.of(context).loadString('assets/messages.json');
    final List<dynamic> data = json.decode(jsonString);

    for (var message in data) {
      _messages.add({
        'message': message['message'],
        'subject': message['subject'],
        'display': message['display'],
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: _buildMessagesList(),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_messages[index]['subject'] ?? ''),
          subtitle: Text(_messages[index]['message'] ?? ''),
          trailing: Text(_messages[index]['display'] ?? ''),
        );
      },
    );
  }
}
