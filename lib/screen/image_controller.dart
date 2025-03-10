
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageController extends ChangeNotifier{

  File? currentImage;

  bool isImageRecent = false;
  String pathImage = "pathImage";
  List<String> pathImagesRecent = [];

  savePathImage(String paths) async{
    pathImagesRecent.insert(0, paths);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(pathImage, pathImagesRecent);
  }

  getPathImage() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? paths = prefs.getStringList(pathImage);
    if(paths != null){
      isImageRecent = true;
      pathImagesRecent = paths;
      currentImage = File(paths.first);
      notifyListeners();
    }
  }

  clearPathImage([String? path]) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(path != null){
      File(path).delete();
      pathImagesRecent.remove(path);
    }else{
      for (var path in pathImagesRecent) {
        File(path).deleteSync();
      }
      pathImagesRecent.clear();
    }
    prefs.setStringList(pathImage, pathImagesRecent);
    notifyListeners();
  }


  void scanImage() async {
    final imagesPath = await CunningDocumentScanner.getPictures(
      noOfPages: 1,
      isGalleryImportAllowed: true,
    );
    if(imagesPath?.isNotEmpty == true){
      setImage(imagesPath!.first, true);
    }
  }

  void saveImage(BuildContext context, String path) async{
    await Gal.putImage(path);
    if(!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Lưu ảnh thành công",
        style: TextStyle(color: Colors.white),),
      duration: Duration(milliseconds: 1000),
    ));}

  void closeImage() {
    currentImage = null;
    notifyListeners();
  }

  void setImage(String path, [bool? savePath]) {
    if(savePath == true) {
      savePathImage(path);
    }

    isImageRecent = false;
    currentImage = File(path);
    notifyListeners();
  }

  void shareImage(String path) {
    Share.shareXFiles([XFile(path)]);
  }
}