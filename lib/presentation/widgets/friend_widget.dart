import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final String logo;
  final String name;
  final String lastMessage;
  final String time;

  const FriendWidget({
    super.key,
    required this.logo,
    required this.name,
    required this.lastMessage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 8, left: 10, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageDetector(
                logo,
                66,
                isCircle: true,
                fit: "cover",
                radius: 100,
              ),
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
                              fontSize: 18,
                              color: AppColors.lightBlack,
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        lastMessage.length > 30
                            ? '${lastMessage.substring(0, 30)}...'
                            : lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
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
