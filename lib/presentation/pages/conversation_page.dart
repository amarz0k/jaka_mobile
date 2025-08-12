import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/bloc/home/conversation/conversation_cubit.dart';
import 'package:chat_app/presentation/bloc/home/conversation/conversation_state.dart';
import 'package:chat_app/presentation/widgets/custom_arrow_back_button.dart';
import 'package:chat_app/presentation/widgets/custom_chat_text_field.dart';
import 'package:chat_app/presentation/widgets/custom_message_widget.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

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

    // Load messages when building the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConversationCubit>().loadMessages(friendId);
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0, // Prevents color change on scroll
        backgroundColor: Colors.white, // Set a consistent background color
        elevation: 0, // Remove shadow
        title: GestureDetector(
          onTap: () {
            context.router.push(
              FriendDetailsRoute(
                friendId: friendId,
                friendName: friendName,
                friendPhotoUrl: friendPhotoUrl,
              ),
            );
          },
          child: Row(
            children: [
              imageDetector(friendPhotoUrl!, 50, isCircle: true, radius: 100),
              const SizedBox(width: 10),
              Text(
                friendName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 60,
        leading: Row(children: [Spacer(), CustomArrowBackButton()]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocListener<ConversationCubit, ConversationState>(
          listener: (context, state) {
            if (state is ConversationFailureState && state.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showToastification(
                  context,
                  state.error!,
                  Colors.red,
                  ToastificationType.error,
                );
              });
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: 20,
                bottom: 120, // Give space for the text field
                left: 0,
                right: 0,
                child: BlocBuilder<ConversationCubit, ConversationState>(
                  builder: (context, state) {
                    if (state is ConversaitonLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ConversationFailureState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Failed to load messages",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please try again",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ConversationLoadedState) {
                      final messages = state.messages ?? [];

                      if (messages.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No messages yet",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Send a message to start the conversation",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        reverse: false, // Show latest messages at bottom
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final bool isSender =
                              message.senderId == (state.currentUser!.id);

                          return CustomMessageWidget(
                            text: message.text,
                            imageUrl: isSender
                                ? state.currentUser!.photoUrl
                                : friendPhotoUrl,
                            dateTime:
                                DateTime.tryParse(message.sentAt) ??
                                DateTime.now(),
                            isSender: isSender,
                            // isSender
                          );
                        },
                      );
                    }

                    return Center(
                      child: Text(
                        "No Messages",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
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
                    // The listener handles state changes automatically
                  },
                  onSendPress: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      context.read<ConversationCubit>().sendMessage(
                        message,
                        friendId,
                      );
                      _messageController.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
