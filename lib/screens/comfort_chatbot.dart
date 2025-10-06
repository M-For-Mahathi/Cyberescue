import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComfortChatbot extends StatefulWidget {
  @override
  _ComfortChatbotState createState() => _ComfortChatbotState();
}

class _ComfortChatbotState extends State<ComfortChatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: _controller.text,
        isUser: true,
      ));
      _isLoading = true;
    });

    final userMessage = _controller.text;
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/comfort'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': userMessage}),
      );

      final data = json.decode(response.body);

      setState(() {
        _isLoading = false;
        if (data['is_bullying']) {
          // Add comforting response with multiple parts
          _messages.add(ChatMessage(
            text: data['empathy'],
            isUser: false,
            isComfort: true,
          ));

          _messages.add(ChatMessage(
            text: data['validation'],
            isUser: false,
            isComfort: true,
          ));

          if (data['specific_comfort'] != null) {
            _messages.add(ChatMessage(
              text: data['specific_comfort'],
              isUser: false,
              isComfort: true,
            ));
          }

          _messages.add(ChatMessage(
            text: data['encouragement'],
            isUser: false,
            isComfort: true,
          ));

          // Add coping strategies
          _messages.add(ChatMessage(
            text: "Here are some ways to cope right now:",
            isUser: false,
            isInfo: true,
          ));

          for (var strategy in data['coping_strategies']) {
            _messages.add(ChatMessage(
              text: "• $strategy",
              isUser: false,
              isInfo: true,
            ));
          }

          // Add resource
          _messages.add(ChatMessage(
            text: "Resource: ${data['resource']}",
            isUser: false,
            isResource: true,
          ));
        } else {
          _messages.add(ChatMessage(
            text: data['message'],
            isUser: false,
            isPositive: true,
          ));
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage(
          text:
              "I want to be here for you, but I'm having technical difficulties. Please try again soon.",
          isUser: false,
          isComfort: true,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Comfort Chat'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.health_and_safety),
            onPressed: _showResources,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.deepPurple[100],
                valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Share what happened or paste a message...",
                border: InputBorder.none,
              ),
              maxLines: 3,
              minLines: 1,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.deepPurple),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _showResources() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Immediate Help Resources"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _resourceTile("Crisis Text Line", "Text HOME to 741741"),
              _resourceTile(
                  "National Suicide Prevention Lifeline", "1-800-273-8255"),
              _resourceTile("The Trevor Project (LGBTQ+)", "1-866-488-7386"),
              _resourceTile(
                  "Cyberbullying Research Center", "cyberbullying.org"),
              _resourceTile("Mental Health America", "mhanational.org"),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _resourceTile(String title, String detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(detail, style: TextStyle(color: Colors.deepPurple)),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isComfort;
  final bool isInfo;
  final bool isResource;
  final bool isPositive;

  ChatMessage({
    required this.text,
    this.isUser = false,
    this.isComfort = false,
    this.isInfo = false,
    this.isResource = false,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bubbleColor;
    CrossAxisAlignment alignment;
    Color textColor = Colors.black;
    IconData? icon;

    if (isUser) {
      bubbleColor = Colors.deepPurple[100]!;
      alignment = CrossAxisAlignment.end;
    } else if (isComfort) {
      bubbleColor = Colors.pink[50]!;
      alignment = CrossAxisAlignment.start;
      icon = Icons.favorite;
      textColor = Colors.pink[800]!;
    } else if (isInfo) {
      bubbleColor = Colors.blue[50]!;
      alignment = CrossAxisAlignment.start;
      icon = Icons.lightbulb_outline;
      textColor = Colors.blue[800]!;
    } else if (isResource) {
      bubbleColor = Colors.green[50]!;
      alignment = CrossAxisAlignment.start;
      icon = Icons.help_outline;
      textColor = Colors.green[800]!;
    } else if (isPositive) {
      bubbleColor = Colors.yellow[50]!;
      alignment = CrossAxisAlignment.start;
      icon = Icons.emoji_emotions_outlined;
      textColor = Colors.orange[800]!;
    } else {
      bubbleColor = Colors.grey[200]!;
      alignment = CrossAxisAlignment.start;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: isComfort
                  ? Colors.pink[100]
                  : isInfo
                      ? Colors.blue[100]
                      : isResource
                          ? Colors.green[100]
                          : isPositive
                              ? Colors.yellow[100]
                              : Colors.grey[300],
              child: Icon(
                icon ?? Icons.psychology,
                size: 16,
                color: isComfort
                    ? Colors.pink
                    : isInfo
                        ? Colors.blue
                        : isResource
                            ? Colors.green
                            : isPositive
                                ? Colors.orange
                                : Colors.grey,
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft:
                          isUser ? Radius.circular(12) : Radius.circular(0),
                      topRight:
                          isUser ? Radius.circular(0) : Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple[200],
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
