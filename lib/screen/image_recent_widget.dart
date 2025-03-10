
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:scan_app/model/recent.dart';
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        color: Color(-15066598),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10,),
              Container(
                width: 100,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: widget.controller.pathImagesRecent.isEmpty
                  ? Center(child: Text("Không có gần đây", style: TextStyle(color: Colors.white),),)
                    : ListView.separated(
                  itemCount: widget.controller.pathImagesRecent.length,
                  itemBuilder: (context, index) {
                    Recent item = widget.controller.pathImagesRecent[index];
                    String pathName = item.path;
                    File image = File(pathName);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        widget.controller.setCurrentImage(item);
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
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(path.basename(pathName), style: TextStyle(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                Text(item.createdDate, style: TextStyle(color: Colors.white60), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ],
                            )),

                            PopupMenuButton(
                                offset: const Offset(-20, 50),
                                color: Colors.grey,
                                itemBuilder: (context){
                                  return [
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.delete_outline_outlined, color: Colors.black,),
                                          SizedBox(width: 5,),
                                          Text("Xóa", style: TextStyle(color: Colors.black),)
                                        ],
                                      ),
                                      onTap: () {
                                        widget.controller.clearPathImage(item);
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
