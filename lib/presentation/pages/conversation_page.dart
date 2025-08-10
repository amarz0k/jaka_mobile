import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/widgets/custom_arrow_back_button.dart';
import 'package:chat_app/presentation/widgets/custom_chat_text_field.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ConversationPage extends StatelessWidget {
  final String friendId;
  final String friendName;
  final String? friendPhotoUrl;

  const ConversationPage({
    super.key,
    required this.friendId,
    required this.friendName,
    this.friendPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _messageController = TextEditingController();
    bool isSendButtonVisible = false;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0, // Prevents color change on scroll
        backgroundColor: Colors.white, // Set a consistent background color
        elevation: 0, // Remove shadow
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.router.push(
                  FriendDetailsRoute(
                    friendId: friendId,
                    friendName: friendName,
                    friendPhotoUrl: friendPhotoUrl,
                  ),
                );
              },
              child: imageDetector(
                friendPhotoUrl!,
                50,
                isCircle: true,
                radius: 100,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              friendName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        leadingWidth: 60,
        leading: Row(children: [Spacer(), CustomArrowBackButton()]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              bottom: 120, // Give space for the text field
              left: 0,
              right: 0,
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Text("data");
                },
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: CustomChatTextField(
                textEditingController: _messageController,
                hintText: "Type a message",
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    isSendButtonVisible = true;
                  } else {
                    isSendButtonVisible = false;
                  }
                },
                isSendButtonVisible: isSendButtonVisible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
