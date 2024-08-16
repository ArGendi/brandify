import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/data.dart';

abstract class StorageServices{
  static Future<String?> uploadFile(File file) async{
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;
      String name = "$id/${DateTime.now()}.png";
      UploadTask task = FirebaseStorage.instance.ref().child(name).putFile(file);
      String? url;
      await task.whenComplete(() async{
        url = await task.snapshot.ref.getDownloadURL();
      });
      if(url != null) return url;
      else return null;
    }
    catch(e){
      log(e.toString());
      return null;
    }
  }

  Future<String?> getFile() async{
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;
      String url = await FirebaseStorage.instance.ref().child("$id.png").getDownloadURL();
      return url;
    }
    catch(e){
      return null;
    }
  }

  Future<List<String>?> getAllFiles() async{
    try{
      var results = await FirebaseStorage.instance.ref().child("profiles/").listAll();
      List<String> urls = [];
      for(var item in results.items){
        String url = await item.getDownloadURL();
        urls.add(url);
      }
      return urls;
    }
    catch(e){
      return null;
    }
  }
}