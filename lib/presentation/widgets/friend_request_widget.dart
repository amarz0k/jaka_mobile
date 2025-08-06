import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/widgets/custom_icon_button.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:flutter/material.dart';

class FriendRequestWidget extends StatelessWidget {
  final String profilePicture;
  final String name;
  final double nameFontSize;
  final bool isIncoming;
  final Function()? onAccept;
  final Function()? onReject;
  const FriendRequestWidget({
    super.key,
    required this.profilePicture,
    required this.name,
    this.nameFontSize = 18,
    required this.isIncoming,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Row(
        children: [
          imageDetector(profilePicture, 66, isCircle: true, radius: 100),
          const SizedBox(width: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.length > 15 ? '${name.substring(0, 15)}...' : name,
                    style: TextStyle(
                      fontSize: nameFontSize,
                      color: AppColors.lightBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isIncoming) ...[
            CustomIconButton(
              size: 40,
              iconColor: Colors.green,
              borderColor: Colors.green,
              icon: Icons.check,
              onPressed: onAccept,
            ),
            const SizedBox(width: 10),
            CustomIconButton(
              size: 40,
              iconColor: Colors.red,
              borderColor: Colors.red,
              icon: Icons.close,
              onPressed: onReject,
            ),
          ],
          if (!isIncoming) ...[
            CustomIconButton(
              size: 40,
              iconColor: Colors.red,
              borderColor: Colors.red,
              icon: Icons.close,
              onPressed: onReject,
            ),
          ],
        ],
      ),
    );
  }
}
