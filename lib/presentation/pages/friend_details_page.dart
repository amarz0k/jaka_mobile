import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/widgets/custom_arrow_back_button.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FriendDetailsPage extends StatelessWidget {
  final String friendId;
  final String friendName;
  final String? friendPhotoUrl;
  const FriendDetailsPage({
    super.key,
    required this.friendId,
    required this.friendName,
    this.friendPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: Row(children: [Spacer(), CustomArrowBackButton()]),
      ),
      body: Center(
        child: Column(
          children: [
            imageDetector(friendPhotoUrl!, 180, isCircle: true, radius: 100),
            const SizedBox(height: 20),
            Text(
              friendName,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: AppColors.lightBlack,
              ),
            ),
            Text(
              friendId,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
