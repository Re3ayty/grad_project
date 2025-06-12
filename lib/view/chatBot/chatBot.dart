import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import '../../model/app_user.dart';


class MessageModel {
  final bool isUser;
  final String message;
  final DateTime time;

  MessageModel({
    required this.isUser,
    required this.message,
    required this.time,
  });
}

class Geminichatbot extends StatefulWidget {
  final AppUser appUser; // Replace `AppUser` with the actual class type you're passing

  const Geminichatbot({Key? key, required this.appUser}) : super(key: key);

  @override
  State<Geminichatbot> createState() => _GeminichatbotState();
}


class _GeminichatbotState extends State<Geminichatbot> {
  static const apiKey = 'AIzaSyDkRkDj-eOj65Tsc10x8Q32pIsUsgZVFHw';

  late final GenerativeModel model;
  late final ChatSession chatSession;

  final List<MessageModel> chat = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
    chatSession = model.startChat();
  }

  // 👇 Build user info prompt
  String buildUserInfoPrompt(AppUser user) {
    return """
User Information:
- Name: ${user.userName}
- Email: ${user.email}
- Date of Birth: ${user.dateOfBirth}
- Phone: ${user.phone}
- Gender: ${user.gender}
- Medical Condition: ${user.medicalCondition}
- Patient or Caregiver: ${user.patientOrCaregiver}
- Allow Caregiver View: ${user.allowCaregiverView}
- Relationship: ${user.relationship}
""";
  }

  Future<void> sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      chat.add(MessageModel(isUser: true, message: message, time: DateTime.now()));
      messageController.clear();
    });

    try {
      final userInfoText = buildUserInfoPrompt(widget.appUser); // 👈 Add user info to prompt

      final response = await chatSession.sendMessage(Content.text("""
You are a healthcare chatbot. The following is the user's profile:

$userInfoText

Now, answer the following question:

$message
"""));

      final botMessage = response.text ?? "No response";

      setState(() {
        chat.add(MessageModel(isUser: false, message: botMessage, time: DateTime.now()));
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        chat.add(MessageModel(isUser: false, message: "⚠️ Failed to respond: $e", time: DateTime.now()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Bot AI"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: chat.length,
              itemBuilder: (context, index) {
                final message = chat[index];
                return userPrompt(
                  isUser: message.isUser,
                  message: message.message,
                  date: DateFormat('hh:mm a').format(message.time),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Message Gemini",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: sendMessage,
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userPrompt({
    required bool isUser,
    required String message,
    required String date,
  }) {
    final bool isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(message);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: isUser
            ? [
          Text(
            date,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEiIuimp_NjTKxjVwmAObJvFZ0qOLnjay1MQ&s',
            ),
          ),
        ]
            : [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/ChatGPT-Logo.svg/1200px-ChatGPT-Logo.svg.png',
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
