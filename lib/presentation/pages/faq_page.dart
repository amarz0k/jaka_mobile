import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = const [
      {
        'q': 'How do I add a friend?',
        'a':
            'Go to the Home tab, enter the friend ID in the Add Friend field, and tap the add button.',
      },
      {
        'q': 'How do I unfriend someone?',
        'a':
            'Long press on a friend in the All Chats list and choose Unfriend from the menu.',
      },
      {
        'q': 'How do I change my password?',
        'a':
            'Open Settings > Change Password. If you haven’t set one yet, choose Set Password.',
      },
      {
        'q': 'How do I turn notifications on/off?',
        'a':
            'Open Settings and toggle Notifications on or off according to your preference.',
      },
      {
        'q': 'Why can’t I send a friend request to myself?',
        'a':
            'For security and app logic reasons, you cannot send a friend request to your own ID.',
      },
      {
        'q': 'Messages are not sending. What should I do?',
        'a':
            'Check your internet connection. The app shows a toast when connectivity is lost or restored.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'FAQs',
          style: TextStyle(
            fontSize: 28,
            color: AppColors.lightBlack,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final item = faqs[index];
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              title: Text(
                item['q']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.lightBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item['a']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
