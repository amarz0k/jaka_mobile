import 'package:auto_route/auto_route.dart';
import 'package:chat_app/presentation/widgets/circle_icon_button.dart';
import 'package:flutter/material.dart';


@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(username: 'John Doe'),
          ],
        ),
      )
    );
  }
}


class TopBar extends StatelessWidget {
  final String username;
  const TopBar({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(width*0.05, height*0.02, width*0.05, height*0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          circleIconButton(Icons.search),
        ],
      ),
    );
  }

 
}