import 'package:camera/camera.dart';
import 'package:fast_call/about/view.dart';
import 'package:fast_call/cnn/components/cnn_display/view.dart';
import 'package:fast_call/cnn/types/type.dart';
import 'package:fast_call/utils/call_link.dart';
import 'package:fast_call/utils/rem_help.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'controller/home.dart';

class CnnHomePage extends StatefulWidget {
  const CnnHomePage({super.key});

  @override
  State<CnnHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CnnHomePage> with WidgetsBindingObserver {

  HomeController controller = HomeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.init(context);
  }

  @override
  Widget build(BuildContext context) {

    final sizeInfo = MediaQuery.of(context).size;

    AppBar appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Scan Dail'),
      actions: [
        IconButton(
            onPressed: () async {
              CallLinkAction.openUrl('https://www.youtube.com/channel/UCGHwT8VkF7gY1SATsor_Now');
            },
            icon: Icon(
              MdiIcons.youtube
            )
        ),
        IconButton(
            onPressed: () async {
              controller.closeReady();
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=> const AboutPage()
                  )
              );
              controller.openReady();
            },
            icon: const Icon(
                Icons.info
            )
        ),
      ],
    );


    return ChangeNotifierProvider.value(
      value: controller,
      child: WillPopScope(
        onWillPop: () async {
          controller.unload();
          return true;
        },
        child: Scaffold(
          appBar: appBar,
          body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                Selector<HomeController, bool>(
                  builder: (context, onLoad, _) {
                    return onLoad ? GestureDetector(
                      onTapDown: (detail) {
                        controller.focusTap(detail);
                      },
                      child: CameraPreview(controller.cameraControllerMax.controller)
                    ) : const SizedBox();
                  },
                  selector: (context, store) => store.onLoad
                ),

                Selector<HomeController, CNNDisplayMode?>(
                    builder: (context, cnn, _) {
                      return cnn != null ? CNNDisplayBord(
                        displayPassMode: cnn,
                        displaySize: sizeInfo,
                        onItemTap: (info) {
                          // 显示快速拨打
                          controller.openQuickJump(info);
                        },
                      ) : const SizedBox();
                    },
                    selector: (context, store) => store.cnnDisplayMode
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.px),
                        topRight: Radius.circular(40.px),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 50.px,
                      ),
                      child: Column(
                        children: [
                          Selector<HomeController, int>(
                            builder: (context, scanNumbers, child) {
                              return scanNumbers > 0 ? SizedBox(
                                height: 140.px,

                                child: (
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40.px
                                      ),
                                      width: double.infinity,
                                      height: 110.px,
                                      child: CupertinoButton(
                                        onPressed: (){
                                          controller.viewAllResult();
                                        },
                                        color: Colors.purple,
                                        child: Text("View $scanNumbers Results"),
                                      ),
                                    ),
                                  )
                                ),
                              ) : (
                                  SizedBox(
                                    height: 140.px,
                                    child: Center(
                                      child: Icon(
                                        Icons.document_scanner_outlined,
                                        size: 100.px,
                                      ),
                                    ),
                                  )
                              );
                            },
                            selector: (context, store) => store.scanNumbers
                          ),
                          Container(
                            height: 90.px,
                            padding: EdgeInsets.only(
                              top: 10.px,
                              bottom: 15.px
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  "Scan email addresses and phone numbers",
                                  style: TextStyle(
                                    fontSize: 30.px
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 40.px,
                  bottom: 300.px,
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleLight();
                    },
                    child: Selector<HomeController, bool>(
                      selector: (context, store) => store.lightIsOpen,
                      builder: (context, isOpen, _) {
                        return Container(
                          width: 100.px,
                          height: 100.px,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.4),
                              borderRadius: BorderRadius.circular(30.px)
                          ),
                          child: Center(
                            child: Icon(
                              Icons.light_mode,
                              color: isOpen ? Colors.orange : Colors.white,
                              size: 60.px,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 监听应用生命周期变化
    if (state == AppLifecycleState.resumed) {
      // 应用进入前台
      controller.openReady();
    } else if (state == AppLifecycleState.paused) {
      // 应用进入后台
      controller.closeReady();
    }
  }

  @override
  void dispose() {
    controller.unload();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}