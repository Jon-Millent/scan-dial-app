import 'package:fast_call/utils/rem_help.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../utils/call_link.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(
                  top: 30.px,
                  bottom: 20.px
                ),
                child: Text(
                  "Scan Dail",
                  style: TextStyle(
                    fontSize: 50.px,
                    fontWeight: FontWeight.bold,
                    color: '#7E57C2'.color
                  ),
                ),
              ),
            ),
            Container(
              width: 200.px,
              height: 200.px,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/ic_launcher.png")
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20.px
              ),
              child: Text(
                "version 1.0.0",
                style: TextStyle(
                  fontSize: 28.px,
                  color: Colors.grey
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                CallLinkAction.openUrl('https://cross.verydog.cn/todo/private/scan-dial/');
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: 20.px
                ),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 28.px,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 50.px,
                left: 50.px,
                right: 50.px
              ),
              child: Text(
                "If you think this app is helpful to you, please give my app a positive review, or you can follow my youtube channel.",
                style: TextStyle(
                  fontSize: 30.px,
                  fontWeight: FontWeight.bold,
                  color: '#333333'.color
                ),
              ),
            ),
            
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 80.px
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 100.px
              ),

              child: FloatingActionButton(
                  onPressed: () {
                    CallLinkAction.openUrl('https://www.youtube.com/channel/UCGHwT8VkF7gY1SATsor_Now');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          MdiIcons.youtube,
                          size: 100.px,
                          color: '#FF0000'.color
                      ),
                      SizedBox(width: 20.px,),
                      Text(
                          "Jon Millent",
                        style: TextStyle(
                          color: '#212121'.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.px
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 30.px
              ),
              child: Text(
                "click the button to open my youtube channel",
                style: TextStyle(
                    fontSize: 28.px,
                    color: Colors.grey
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

