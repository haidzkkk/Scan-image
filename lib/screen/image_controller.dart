
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:scan_app/model/recent.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uri_to_file/uri_to_file.dart';

class ImageController extends ChangeNotifier{

  Recent? currentImage;

  bool isImageRecent = false;
  String pathImage = "pathImage";
  List<Recent> pathImagesRecent = [];

  saveLocalImage(Recent recent) async{
    pathImagesRecent.insert(0, recent);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(pathImage, Recent.toListJson(pathImagesRecent));
  }

  getLocalImage() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(pathImage);
    if(json == null || json.isEmpty) return;

    isImageRecent = true;
    pathImagesRecent = Recent.fromListJson(json);
    currentImage = pathImagesRecent.first;
    notifyListeners();

  }

  clearPathImage([Recent? recent]) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(recent != null){
      deleteImageFromGallery(recent);
      pathImagesRecent.remove(recent);
    }else{
      for (var path in pathImagesRecent) {
        deleteImageFromGallery(path);
      }
      pathImagesRecent.clear();
    }
    prefs.setString(pathImage, Recent.toListJson(pathImagesRecent));
    setCurrentImage(pathImagesRecent.firstOrNull);
  }


  void scanImage() async {
    final imagesPath = await CunningDocumentScanner.getPictures(
      noOfPages: 1,
      isGalleryImportAllowed: true,
    );
    if(imagesPath?.isNotEmpty != true) return;

    Recent? recent = await saveImage(imagesPath!.first);
    if(recent == null) return;
    setCurrentImage(recent);
  }

  Future<Recent?> saveImage(String pathLocal) async{
    var response = await ImageGallerySaverPlus.saveFile(pathLocal);

    File(pathLocal).deleteSync();

    String? uriRes = response['filePath'];
    if(uriRes == null) return null;
    File fileGallery = await toFile(uriRes);
    if(!(await fileGallery.exists())) return null;

    var recent = Recent(
        uri: uriRes,
        path: fileGallery.path,
        createdDate: DateTime.now().toString()
    );
    saveLocalImage(recent);
    return recent;
  }

  void closeImage() {
    currentImage = null;
    notifyListeners();
  }

  void setCurrentImage(Recent? recent) {
    isImageRecent = false;
    currentImage = recent;
    notifyListeners();
  }

  void shareImage(String path) {
    Share.shareXFiles([XFile(path)]);
  }

  Future<bool> deleteImageFromGallery(Recent recent) async {
    try {
      final bool success = await MethodChannel('gallery_manager')
          .invokeMethod('deleteImage', {'imageUri': recent.uri});
      return success;
    } catch (e) {
      print("Lỗi khi xóa ảnh: $e");
      return false;
    }
  }
}