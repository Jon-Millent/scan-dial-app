import 'package:fast_call/cnn/types/type.dart';
import 'package:fast_call/plugins/link_getter/link.dart';
import 'package:fast_call/plugins/link_getter/types/type.dart';
import 'package:fast_call/utils/call_link.dart';
import 'package:fast_call/utils/rem_help.dart';
import 'package:fast_call/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReasoningPage extends StatefulWidget {

  final CNNDisplayMode cnnDisplayMode;

  const ReasoningPage({
    super.key,
    required this.cnnDisplayMode
  });

  @override
  State<StatefulWidget> createState() => _ReasoningPageState();

}


class _ReasoningPageState extends State<ReasoningPage> {

  List<LinkGetterItemMode> better = [];

  bool isOrder = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    better = [...widget.cnnDisplayMode.better];
  }

  void orderByLinkLength() {
    setState(() {
      if (isOrder) {
        better.sort((a, b) => a.realLink.length.compareTo(b.realLink.length));
      } else {
        better.sort((a, b) => b.realLink.length.compareTo(a.realLink.length));
      }
      isOrder = !isOrder;
    });
  }

  void filterBetterLessThan4() {
    setState(() {
      better = better.where((element) {
        if (element.isPhoneNumber) {
          return element.realLink.length > 5;
        }
        return true;
      }).toList();
    });
  }


  void _showPhoneNumberPopupMenu(
      BuildContext context,
      Offset tapPosition,
      LinkGetterItemMode info
    ) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(
      tapPosition.dx,
      tapPosition.dy,
      overlay.size.width - tapPosition.dx,
      overlay.size.height - tapPosition.dy,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'sms',
          child: const Text('Send SMS'),
          onTap: () {
            CallLinkAction.sendSMS(info.realLink);
          },
        ),
        PopupMenuItem<String>(
          value: 'contacts',
          child: const Text('Add Contacts'),
          onTap: () {
            CallLinkAction.addConcat(info.realLink);
          },
        ),
        PopupMenuItem<String>(
          value: 'share',
          child: const Text('Share'),
          onTap: () {
            CallLinkAction.sharePhoneNumber(info.realLink);
          },
        )
      ],
    );
  }

  void _showEmailPopupMenu(
      BuildContext context,
      Offset tapPosition,
      LinkGetterItemMode info
    ) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(
      tapPosition.dx,
      tapPosition.dy,
      overlay.size.width - tapPosition.dx,
      overlay.size.height - tapPosition.dy,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'option2',
          child: const Text('Share'),
          onTap: () {
            CallLinkAction.shareEmail(info.realLink);
          },
        )
      ],
    );
  }

  void _showUrlPopupMenu(
      BuildContext context,
      Offset tapPosition,
      LinkGetterItemMode info
      ) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(
      tapPosition.dx,
      tapPosition.dy,
      overlay.size.width - tapPosition.dx,
      overlay.size.height - tapPosition.dy,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'option2',
          child: const Text('Share'),
          onTap: () {
            CallLinkAction.shareEmail(info.realLink);
          },
        )
      ],
    );
  }

  Widget callCard (LinkGetterItemMode info) {
    return GestureDetector(
      onTap: (){
        if (info.isPhoneNumber) {
          CallLinkAction.callPhoneNumber(info.realLink);
        } else if (info.isEmail) {
          CallLinkAction.sendEmail(info.realLink);
        } else if (info.isUrl) {
          CallLinkAction.openUrl(info.realLink);
        }
      },
      child: Container(
          padding: EdgeInsets.only(
            left: 30.px,
            right: 30.px,
            top: 30.px,
            bottom: 30.px,
          ),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: Colors.black12
                  )
              )
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 74.px,
                    height: 74.px,
                    decoration: BoxDecoration(
                        color: info.getColor,
                        borderRadius: BorderRadius.circular(10.px)
                    ),
                    child: Center(
                      child: Icon(
                        info.getIcon,
                        color: Colors.white,
                        size: 50.px,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 30.px
                      ),
                      child: Text(
                        info.link,
                        style: TextStyle(
                            fontSize: 30.px
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTapUp: (details) {
                      if (info.isPhoneNumber) {
                        _showPhoneNumberPopupMenu(context, details.globalPosition, info);
                      } else if(info.isEmail) {
                        _showEmailPopupMenu(context, details.globalPosition, info);
                      } else if(info.isUrl) {
                        _showUrlPopupMenu(context, details.globalPosition, info);
                      }
                    },
                    child: SizedBox(
                      width: 70.px,
                      height: 46.px,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                            Icons.more_horiz_outlined
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20.px,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          CallLinkAction.copy(info.realLink);
                          CatToast.showToast('Copied');
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 60.px,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                  Icons.copy_sharp
                              ),
                              SizedBox(width: 10.px,),
                              const Text("Copy"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          if (info.isPhoneNumber) {
                            CallLinkAction.callPhoneNumber(info.realLink);
                          } else if (info.isEmail) {
                            CallLinkAction.sendEmail(info.realLink);
                          } else if (info.isUrl) {
                            CallLinkAction.openUrl(info.realLink);
                          }
                        },
                        child: Builder(
                          builder: (context) {

                            String displayText = "";
                            if (info.isPhoneNumber) {
                              displayText = "Dial";
                            } else if (info.isEmail) {
                              displayText = "Send Email";
                            } else if (info.isUrl) {
                              displayText = "Open Url";
                            }

                            return Container(
                              height: 80.px,
                              decoration: BoxDecoration(
                                color: '#C4EED0'.color,
                                borderRadius: BorderRadius.circular(20.px)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    info.getIcon
                                  ),
                                  SizedBox(width: 10.px,),
                                  Text(displayText)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(

        slivers: [
          SliverAppBar(
            title: const Text("Results"),
            floating: true,
            actions: [

              PopupMenuButton<String>(
                icon: Icon(
                    MdiIcons.filterOutline
                ),
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'option1',
                      child: const Text('Hide numbers <= 5'),
                      onTap: () {
                        filterBetterLessThan4();
                      },
                    ),
                    PopupMenuItem<String>(
                      value: 'option2',
                      child: const Text('Order by link length'),
                      onTap: () {
                        orderByLinkLength();
                      },
                    )
                  ];
                },
              ),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.share
                ),
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'option1',
                      child: const Text('Copy All'),
                      onTap: () {
                        CallLinkAction.copy(
                          LinkGetter.getAllListSpaces(better)
                        );
                        CatToast.showToast('Copied');
                      },
                    )
                  ];
                },
              ),

            ],
          ),


          SliverList.builder(
            itemBuilder: (context, index) {
              return callCard(better[index]);
            },
            itemCount: better.length,
          )
        ],
      ),
    );
  }
}