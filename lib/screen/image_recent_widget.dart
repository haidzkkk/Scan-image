
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:scan_app/screen/image_controller.dart';

class ImageRecentWidget extends StatefulWidget {
  const ImageRecentWidget(this.controller, {super.key});

  final ImageController controller;

  @override
  State<ImageRecentWidget> createState() => _ImageRecentWidgetState();
}

class _ImageRecentWidgetState extends State<ImageRecentWidget> {

  void updateUI() => setState(() {});

  @override
  void initState() {
    widget.controller.addListener(updateUI);
    super.initState();
  }
  @override
  void dispose() {
    widget.controller.removeListener(updateUI);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10,),
              Container(width: 100, height: 5, color: Colors.red,),
              SizedBox(height: 10,),
              Expanded(
                child: widget.controller.pathImagesRecent.isEmpty
                  ? Center(child: Text("Không có gần đây", style: TextStyle(color: Colors.white),),)
                    : ListView.separated(
                  itemCount: widget.controller.pathImagesRecent.length,
                  itemBuilder: (context, index) {
                    String pathName = widget.controller.pathImagesRecent[index];
                    File image = File(pathName);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        widget.controller.setImage(pathName);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                                width: 16 * 6.25,
                                height: 9 * 6.25,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7)
                                ),
                                child: Image.file(image, )
                            ),
                            SizedBox(width: 20,),
                            Expanded(child: Text(path.basename(pathName), style: TextStyle(color: Colors.white),)),

                            PopupMenuButton(
                                offset: const Offset(-20, 50),
                                color: Colors.grey,
                                itemBuilder: (context){
                                  return [
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.download),
                                          SizedBox(width: 5,),
                                          Text("Lưu", style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                      onTap: () {
                                        widget.controller.saveImage(context, pathName);
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.share),
                                          SizedBox(width: 5,),
                                          Text("Chia sẻ", style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                      onTap: () {
                                        widget.controller.shareImage(pathName);
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.delete_outline_outlined, color: Colors.black,),
                                          SizedBox(width: 5,),
                                          Text("Xóa", style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                      onTap: () {
                                        widget.controller.clearPathImage(pathName);
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.clear, color: Colors.black,),
                                          SizedBox(width: 5,),
                                          Text("Xóa tất cả", style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                      onTap: () {
                                        widget.controller.clearPathImage();
                                      },
                                    ),
                                  ];
                                },
                                icon: Icon(Icons.more_vert, color: Colors.white, size: 20,)
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(height: 1, color: Colors.black12,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
