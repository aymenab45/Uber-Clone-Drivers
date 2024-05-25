import 'package:drivres_app/buisnis_logic/notifications_system/push_notifications_system.dart';
import 'package:drivres_app/data/ride_request_model/ride_request_model.dart';
import 'package:drivres_app/presetation/app_manager/color_manager/colormanager.dart';
import 'package:drivres_app/presetation/app_manager/text_manager/textmanager.dart';
import 'package:drivres_app/presetation/buttou_manager/buttomn_%C3%B9anager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../ChatScreen/chat-screen.dart';

class NotificationDialogue extends StatefulWidget {
  final RideRequest rideRequest;
  final String message;
  final String roomId;

  const NotificationDialogue(
      {super.key,
      required this.rideRequest,
      required this.message,
      required this.roomId});

  @override
  State<NotificationDialogue> createState() => _NotificationDialogueState();
}

class _NotificationDialogueState extends State<NotificationDialogue> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 300),
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.03),
              child: MyDefaultTextStyle(
                  text: "Start New Cnversation",
                  height: height * 0.03,
                  color: black,
                  bold: true),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      left: width * 0.06,
                      right: width * 0.06,
                    ),
                    child: MyDefaultTextStyle(
                        text: "you have new message from  ${widget.message}",
                        height: height * 0.015,
                        color: black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Defaultbutton(
                    functon: () {
                      Navigator.pop(context);
                      Provider.of<NotificationsSystem>(context, listen: false)
                          .assetsAudioPlayer
                          .stop();
                    },
                    text: "CANCEL",
                    height: height * 0.06,
                    width: width * 0.3,
                    color: Colors.red,
                    fontsize: height * 0.018),
                SizedBox(
                  width: width * 0.05,
                ),
                Defaultbutton(
                    functon: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: const ChatScreen()));
                    },
                    text: "ACCEPT",
                    height: height * 0.06,
                    width: width * 0.3,
                    color: Colors.green,
                    fontsize: height * 0.018),
              ],
            ),
            SizedBox(
              height: height * 0.04,
            )
          ],
        ),
      ),
    );
  }
}
