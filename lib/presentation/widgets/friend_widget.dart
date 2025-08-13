import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final String logo;
  final String name;
  final String? lastMessage;
  final String? time;
  final Function()? onTap;
  final Function()? onLongPress;

  final double nameFontSize;
  final double lastMessageFontSize;

  const FriendWidget({
    super.key,
    required this.logo,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.onTap,
    this.onLongPress,
    this.nameFontSize = 18,
    this.lastMessageFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 8, left: 10, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageDetector(logo, 66, isCircle: true, radius: 100),
              const SizedBox(width: 10),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name.length > 15
                                ? '${name.substring(0, 15)}...'
                                : name,
                            style: TextStyle(
                              fontSize: nameFontSize,
                              color: AppColors.lightBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            time ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        lastMessage == null
                            ? ''
                            : lastMessage!.length > 30
                            ? '${lastMessage!.substring(0, 30)}...'
                            : lastMessage!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: lastMessageFontSize,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
