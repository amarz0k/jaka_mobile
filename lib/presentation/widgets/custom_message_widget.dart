import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:chat_app/utils/date_style_converter.dart';
import 'package:flutter/material.dart';

class CustomMessageWidget extends StatelessWidget {
  final String? text;
  final String? imageUrl;
  final DateTime? dateTime;
  final bool isSender;
  const CustomMessageWidget({
    super.key,
    this.text,
    this.imageUrl,
    this.dateTime,
    this.isSender = false,
  });

  @override
  Widget build(BuildContext context) {
    final Radius circularRadius = Radius.circular(30);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: isSender
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: imageDetector(imageUrl!, 45, isCircle: true),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xfff2f2f2),
                          borderRadius: BorderRadius.only(
                            topLeft: circularRadius,
                            topRight: circularRadius,
                            bottomRight: circularRadius,
                          ),
                        ),
                        child: Text(
                          text!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1000,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.lightBlack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Text(
                        DateStyleConverter.covertToTimeStyle(dateTime!),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightBlack,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
