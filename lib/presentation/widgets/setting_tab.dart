import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:flutter/material.dart';

class SettingTab extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback? onTap;
  final bool? value;
  final void Function(bool value)? onChanged;
  final bool? isSwitch;
  const SettingTab({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.isSwitch = false,
    this.onChanged,
    this.value = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(0),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
        child: Row(
          children: [
            imageDetector(icon, 30, color: Colors.grey.shade500),
            const SizedBox(width: 30),
            Text(
              label,
              style: TextStyle(
                color: AppColors.lightBlack,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            isSwitch == true
                ? Switch(value: value ?? false, onChanged: onChanged)
                : Icon(Icons.arrow_forward_ios_sharp, size: 18),
          ],
        ),
      ),
    );
  }
}
