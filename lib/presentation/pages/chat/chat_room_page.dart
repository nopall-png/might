import 'package:flutter/material.dart';
import '../../../data/models/dummy_messages.dart';
import '../../../data/models/message_model.dart';

class ChatRoomPage extends StatelessWidget {
  final String fighterName;

  const ChatRoomPage({super.key, required this.fighterName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B164A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A3FFF),
        title: Text(
          fighterName,
          style: const TextStyle(fontFamily: 'Press Start 2P', fontSize: 12),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyMessages.length,
              itemBuilder: (context, index) {
                final msg = dummyMessages[index];
                return Align(
                  alignment: msg.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: msg.isMe
                          ? const LinearGradient(
                              colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF4C2C82), Color(0xFF4C2C82)],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: msg.isMe
                            ? const Color(0xFFF9F8FF)
                            : const Color(0xFF7A3FFF),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFF1A0D2E)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C2C82),
                      border: Border.all(color: Color(0xFFA96CFF), width: 2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    height: 50,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Type a message...",
                        style: TextStyle(color: Color(0xFFB6A9D7)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                    ),
                    border: Border.all(color: Color(0xFFF9F8FF), width: 2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
