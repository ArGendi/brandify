import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/add_product/add_product_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/size.dart';
import 'package:tabe3/view/screens/products/products_screen.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.product != null) {
      AddProductCubit.get(context).setProduct(widget.product!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: AddProductCubit.get(context).formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _imageBottomSheet(context);
                      },
                      child: BlocBuilder<AddProductCubit, AddProductState>(
                        builder: (context, state) {
                          return Container(
                            width: double.infinity,
                            height: 180,
                            color: mainColor,
                            child: AddProductCubit.get(context).image == null
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Add photo",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                : Image.file(
                                    AddProductCubit.get(context).image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 180,
                                  ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      initial: AddProductCubit.get(context).product.name,
                      text: "Name",
                      onSaved: (value) {
                        AddProductCubit.get(context).product.name = value;
                      },
                      onValidate: (value) {
                        if (value!.isEmpty) {
                          return "Enter name";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      initial:
                          AddProductCubit.get(context).product.price != null
                              ? AddProductCubit.get(context)
                                  .product
                                  .price
                                  .toString()
                              : null,
                      keyboardType: TextInputType.number,
                      text: "Price",
                      onSaved: (value) {
                        if (value!.isNotEmpty) {
                          AddProductCubit.get(context).product.price =
                              int.parse(value);
                        }
                      },
                      onValidate: (value) {
                        if (value!.isEmpty) {
                          return "Enter price";
                        } else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    BlocBuilder<AddProductCubit, AddProductState>(
                      builder: (context, state) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    initial: AddProductCubit.get(context)
                                        .product
                                        .sizes[i]
                                        .name,
                                    text: "Size",
                                    onSaved: (value) {
                                      AddProductCubit.get(context)
                                          .product
                                          .sizes[i]
                                          .name = value;
                                    },
                                    // onChange: (value){
                                    //   AddProductCubit.get(context).product.sizes[i].name = value;
                                    // },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CustomTextFormField(
                                    initial: AddProductCubit.get(context)
                                                .product
                                                .sizes[i]
                                                .quantity !=
                                            null
                                        ? AddProductCubit.get(context)
                                            .product
                                            .sizes[i]
                                            .quantity
                                            .toString()
                                        : null,
                                    keyboardType: TextInputType.number,
                                    text: "Quantity",
                                    onSaved: (value) {
                                      AddProductCubit.get(context)
                                          .product
                                          .sizes[i]
                                          .quantity = int.parse(value!);
                                    },
                                    // onChange: (value){
                                    //   AddProductCubit.get(context).product.sizes[i].quantity = int.parse(value!);
                                    // },
                                  ),
                                ),
                                if (i != 0)
                                  SizedBox(
                                    width: 10,
                                  ),
                                if (i != 0)
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: IconButton(
                                      onPressed: () {
                                        AddProductCubit.get(context)
                                            .removeSize(i);
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                          separatorBuilder: (context, i) => SizedBox(
                            height: 10,
                          ),
                          itemCount: AddProductCubit.get(context)
                              .product
                              .sizes
                              .length,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      text: "Add another size",
                      onPressed: () {
                        AddProductCubit.get(context).addSize();
                      },
                      bgColor: Colors.black,
                    ),
                  ],
                ),
              ),
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if(state is LoadingEditProductState || state is LoadingOneProductState){
                    return Center(child: CircularProgressIndicator(color: mainColor,),);
                  }
                  else{
                    return CustomButton(
                      text: widget.product == null ? "Add" : "Edit",
                      onPressed: () async {
                        Product? product =
                            await AddProductCubit.get(context).onDone(context);
                        if (product != null) {
                          if (widget.product == null) {
                            ProductsCubit.get(context).addProduct(product, context);
                            
                          } else {
                            ProductsCubit.get(context).editProduct(product, context);
                          }
                        }
                      },
                      //bgColor: Colors.black,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _imageBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      //isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomButton(
                    icon: Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                    text: "Photos",
                    onPressed: () {
                      AddProductCubit.get(context)
                          .getImage(ImageSource.gallery, context);
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    text: "Camera",
                    onPressed: () {
                      AddProductCubit.get(context).getImage(ImageSource.camera, context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
