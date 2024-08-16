import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/side.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';

class SellScreen extends StatefulWidget {
  final Product product;
  const SellScreen({super.key, required this.product});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: SellCubit.get(context).formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                keyboardType: TextInputType.number,
                text: "Sell price",
                onSaved: (value) {
                  if (value!.isNotEmpty)
                    SellCubit.get(context).price = int.parse(value);
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
              Text("Choose the size"),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2),
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () {
                      if (widget.product.sizes[i].quantity! > 0)
                        SellCubit.get(context)
                            .selectSize(widget.product.sizes[i]);
                    },
                    child: BlocBuilder<SellCubit, SellState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: SellCubit.get(context).selectedSize ==
                                    widget.product.sizes[i]
                                ? mainColor
                                : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              widget.product.sizes[i].name.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration:
                                      widget.product.sizes[i].quantity == 0
                                          ? TextDecoration.lineThrough
                                          : null),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                itemCount: widget.product.sizes.length,
              ),
              SizedBox(
                height: 15,
              ),
              Text("Choose side expenses"),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5),
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () {
                      if (SidesCubit.get(context).sides[i].quantity! > 0)
                        SellCubit.get(context)
                            .selectSides(SidesCubit.get(context).sides[i]);
                    },
                    child: BlocBuilder<SellCubit, SellState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: SellCubit.get(context).selected.contains(
                                    SidesCubit.get(context).sides[i])
                                ? mainColor
                                : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              SidesCubit.get(context)
                                  .sides[i]
                                  .name
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration: SidesCubit.get(context)
                                              .sides[i]
                                              .quantity ==
                                          0
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                itemCount: SidesCubit.get(context).sides.length,
              ),
              //SizedBox(height: 15,),
              Row(
                children: [
                  BlocBuilder<SellCubit, SellState>(
                    builder: (context, state) {
                      return Checkbox(
                        value: SellCubit.get(context).onePercent,
                        onChanged: (value) {
                          SellCubit.get(context).checkOnePercent();
                        },
                        activeColor: mainColor,
                      );
                    },
                  ),
                  //SizedBox(width: 10,),
                  Text("1% delivery fees"),
                ],
              ),
              CustomTextFormField(
                keyboardType: TextInputType.number,
                text: "Any extra expenses",
                onSaved: (value) {
                  if (value!.isNotEmpty)
                    SellCubit.get(context).extra = int.parse(value);
                },
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     IconButton(
              //       onPressed: (){},
              //       icon: Icon(Icons.minimize),
              //     ),
              //     Text(),
              //     IconButton(
              //       onPressed: (){},
              //       icon: Icon(Icons.add),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<SellCubit, SellState>(
                builder: (context, state) {
                  if(state is LoadingSellState){
                    return Center(child: CircularProgressIndicator(color: mainColor,),);
                  }
                  else{
                    return CustomButton(
                      text: "Confirm",
                      onPressed: () {
                        SellCubit.get(context).onDone(context, widget.product);
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
