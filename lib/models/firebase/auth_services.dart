import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/data.dart';
import 'package:tabe3/models/handler/firebase_error_handler.dart';

abstract class AuthServices{
  static Future<Data> login(String email, String password) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return Data<String>("done", Status.success);
    }
    on FirebaseAuthException catch(e){
      return Data<String>(FirebaseErrorHandler.getError(e.code), Status.fail);
    }
    catch(e){
      log(e.toString());
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data<String>> register(String email, String password) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return Data<String>("done", Status.success);
    }
    on FirebaseAuthException catch(e){
      return Data<String>(FirebaseErrorHandler.getError(e.code), Status.fail);
    }
    catch(e){
      log(e.toString());
      return Data<String>(e.toString(), Status.fail);
    }
  }
}