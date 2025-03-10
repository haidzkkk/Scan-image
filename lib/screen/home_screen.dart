import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scan_app/screen/image_controller.dart';

import 'image_recent_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ImageController controller = ImageController();
  void updateUI() => setState(() {});

  @override
  void initState() {
    controller.addListener(updateUI);
    controller.getLocalImage();
    super.initState();
  }
  @override
  void dispose() {
    controller.removeListener(updateUI);
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.2),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
                child: controller.currentImage != null
                    ? Image.file(File(controller.currentImage!.path), fit: BoxFit.contain,)
                    : Center(
                  child: GestureDetector(
                    onTap: (){
                      controller.scanImage();
                    },
                    child: Text("Chưa có ảnh quét ngay",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                    builder: (context) {
                      bool isRecent = controller.isImageRecent && controller.currentImage != null;
                      return Center(
                          child: GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                  ),
                                  builder: (context) => ImageRecentWidget(controller)
                              );
                            },
                            child: Container(
                                padding: EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(100)
                                ),
                                child: Text(isRecent
                                    ? "Ảnh gần đây"
                                    : "Xem lịch sử",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)
                            ),
                          )
                      );
                    }
                ),
                SizedBox(height: 10,),
                Material(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if(controller.currentImage != null)
                        IconButton(
                            onPressed: (){
                              controller.closeImage();
                            },
                            icon: Icon(Icons.close, color: Colors.white, size: 35,)
                        ),
                      GestureDetector(
                        onTap: (){
                          controller.scanImage();
                        },
                        child: Container(
                          width: sized.width * 0.15,
                          height: sized.width * 0.15,
                          margin: EdgeInsetsDirectional.all(sized.width * 0.05),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(200),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.amber.withValues(alpha: 0.2),
                                    spreadRadius: 10,
                                    blurRadius: 10,
                                    blurStyle: BlurStyle.inner
                                )
                              ]
                          ),
                          child: Icon(Icons.camera),
                        ),
                      ),
                      if(controller.currentImage != null)
                        IconButton(
                            onPressed: (){
                              controller.shareImage(controller.currentImage!.path);
                            },
                            icon: Icon(Icons.send, color: Colors.amber, size: 35,)
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
