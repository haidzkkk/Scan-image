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
    controller.getPathImage();
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
                    ? Image.file(controller.currentImage!, fit: BoxFit.contain,)
                    : Center(
                  child: Text("Chưa có ảnh",
                    style: TextStyle(color: Colors.white),
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
                              showModalBottomSheet(context: context, builder: (context) => ImageRecentWidget(controller));
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
                        ...[
                          IconButton(
                              onPressed: (){
                                controller.closeImage();
                              },
                              icon: Icon(Icons.close, color: Colors.white, size: 35,)
                          ),
                          SizedBox(width: 40,)
                        ],
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
                        ...[
                          IconButton(
                              onPressed: (){
                                controller.saveImage(context, controller.currentImage!.path);
                              },
                              icon: Icon(Icons.download, color: Colors.white, size: 35,)
                          ),
                          SizedBox(
                            width: 40,
                            child: IconButton(
                                onPressed: (){
                                  controller.shareImage(controller.currentImage!.path);
                                },
                                icon: Icon(Icons.send, color: Colors.amber, size: 35,)
                            ),
                          ),
                        ]
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
