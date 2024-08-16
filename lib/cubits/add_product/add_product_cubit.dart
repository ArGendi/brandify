import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/firebase/storage_services.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/size.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  late Product product;
  File? image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddProductCubit() : super(AddProductInitial()){
    product = Product();
    product.sizes = [ProductSize()];
  }
  static AddProductCubit get(BuildContext context) => BlocProvider.of(context);

  void getImage(ImageSource source, BuildContext context) async{
    ImagePicker picker = ImagePicker();
      var xfile =
          await picker.pickImage(source: source, imageQuality: 60);
      if (xfile != null) {
        image = File(xfile.path);
        emit(GetImageState());
        var data = await StorageServices.uploadFile(image!);
        product.image = data;
        log("Image:: ${product.image}");
      }
  }

  void setProduct(Product p){
    product = p;
  }

  void addSize(){
    product.sizes.add(ProductSize());
    emit(AddSizeState());
  }

  void removeSize(int i){
    product.sizes.removeAt(i);
    emit(RemoveSizeState());
  }

  Future<Product?> onDone(BuildContext context) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      //emit(SuccessProductState());
      return product;
    }
    else return null;
  }
}
