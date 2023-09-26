import 'dart:math';
import 'package:fast_call/plugins/link_getter/types/type.dart';
import 'package:fast_call/plugins/utils/link_type_getter.dart';
import 'package:flutter/material.dart';
import '../../types/type.dart';

class CNNDisplayBord extends StatefulWidget {
  final CNNDisplayMode displayPassMode;
  final Size displaySize;

  final ValueChanged<LinkGetterItemMode> onItemTap;

  const CNNDisplayBord({
    super.key,
    required this.displayPassMode,
    required this.displaySize,
    required this.onItemTap
  });

  @override
  State<StatefulWidget> createState() => _DisplayBordState();
}

class _DisplayBordState extends State<CNNDisplayBord> {

  double cnnWidth = 0;
  double cnnHeight = 0;

  bool isInit = false;
  double biliX = 0;
  double biliY = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final blocks = widget.displayPassMode.better;

    if (!isInit) {
      isInit = true;

      Size metaSize = widget.displayPassMode.imageSize;


      cnnWidth = min(metaSize.width, metaSize.height);
      cnnHeight = max(metaSize.width, metaSize.height);

      double displayHeight = widget.displaySize.width / (cnnWidth / cnnHeight);

      biliX = widget.displaySize.width / cnnWidth;
      biliY = displayHeight / cnnHeight;

    }

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Stack(
        children: [
          for (final item in blocks)
            getTextLabel(item)
        ],
      ),
    );
  }

  Widget getTextLabel (LinkGetterItemMode item) {

    double top = item.textBlock.boundingBox.top * biliY;
    double left = item.textBlock.boundingBox.left * biliX;

    double width = item.textBlock.boundingBox.width * biliX;
    double height = item.textBlock.boundingBox.height * biliY;

    return Positioned(
      left: left - 20,
      top: top - 20,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              widget.onItemTap(item);
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                top: 20
              ),
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(.2),
                  border: Border.all(
                      color: Colors.purple.withOpacity(.6),
                      style: BorderStyle.solid
                  )
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                widget.onItemTap(item);
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: LinkTypeGetter.getLinkColorByType(item.type),
                ),
                child: Icon(
                  LinkTypeGetter.getLinkIconByType(item.type),
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}