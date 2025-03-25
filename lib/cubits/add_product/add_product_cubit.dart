import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/firebase/storage_services.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/size.dart';
import 'package:tabe3/models/size_quantity_controller.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  late Product product;
  File? image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<SizeQuantityController> sizesControllers = [];
  TextEditingController codeController = TextEditingController();

  AddProductCubit() : super(AddProductInitial()){
    product = Product();
    product.sizes = [ProductSize()];
    sizesControllers = [SizeQuantityController()];
  }
  static AddProductCubit get(BuildContext context) => BlocProvider.of(context);

  void getImage(ImageSource source) async{
    ImagePicker picker = ImagePicker();
      var xfile = await picker.pickImage(source: source);
      if (xfile != null) {
        product.image = xfile.path;
        emit(GetImageState());
        log("Image:: ${product.image}");
      }
  }

  void setProduct(Product p){
    product = p;
    sizesControllers = [for(var item in p.sizes) SizeQuantityController(
      size: TextEditingController(text: item.name),
      quantity: TextEditingController(text: item.quantity.toString())
    )];
    codeController.text = p.code ?? "";
  }

  void addSize(){
    product.sizes.add(ProductSize());
    sizesControllers.add(SizeQuantityController());
    emit(AddSizeState());
  }

  void removeSize(int i){
    product.sizes.removeAt(i);
    sizesControllers.removeAt(i);
    emit(RemoveSizeState());
  }

  Future<Product?> validate(BuildContext context) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      for(int i=0; i<sizesControllers.length; i++){
        if(sizesControllers[i].quantityController.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Enter the quantity"), backgroundColor: Colors.red,)
          );
          return null;
        }
        if(sizesControllers[i].sizeController.text.isEmpty){
          product.sizes[i].name = "Regular";
        }
        else product.sizes[i].name = sizesControllers[i].sizeController.text;
        product.sizes[i].quantity = int.parse(sizesControllers[i].quantityController.text);
      }
      //emit(SuccessProductState());
      return product;
    }
    else return null;
  }

  void setCode(String value){
    product.code = value;
    codeController.text = value;
    emit(ProductChangedState());
  }
}
