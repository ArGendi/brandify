import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell_side.dart';
import 'package:tabe3/models/side.dart';
import 'package:tabe3/view/screens/calculate_percent_screen.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';
import 'package:tabe3/view/widgets/quantity_row.dart';

class SellScreen extends StatefulWidget {
  final Product product;
  const SellScreen({super.key, required this.product});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SellCubit.get(context).sides = [
      for (var item in SidesCubit.get(context).sides) SellSide(item)
    ];
    if (widget.product.sizes.length == 1) {
      SellCubit.get(context).selectedSize = widget.product.sizes[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell 🤑"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CalculatePercentScreen()));
            },
            icon: Icon(Icons.percent),
          )
        ],
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
                height: 20,
              ),
              Text("Where did you sell it ?"),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<SellCubit,SellState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.online);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.online ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.online
                                    ? mainColor
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              "Online",
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.online
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.offline);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.offline ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.offline
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              "Offline",
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.offline
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.inEvent);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.inEvent ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.inEvent
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              "In Event",
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.inEvent
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          SellCubit.get(context).setPlace(SellPlace.other);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SellCubit.get(context).place ==
                                        SellPlace.other ? mainColor : null,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: SellCubit.get(context).place ==
                                        SellPlace.other
                                    ? Colors.white
                                    : Colors.grey,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text(
                              "Other",
                              style: TextStyle(
                                color: SellCubit.get(context).place ==
                                        SellPlace.other
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (widget.product.sizes.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("Choose the size"),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.1),
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
                                        fontSize: 14,
                                        decoration:
                                            widget.product.sizes[i].quantity ==
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
                      itemCount: widget.product.sizes.length,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Text("Quantity want to sell"),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<SellCubit, SellState>(
                builder: (context, state) {
                  return QuantityRow(
                    text: SellCubit.get(context).quantity.toString(),
                    onDec: () {
                      SellCubit.get(context).decQuantity(context);
                    },
                    onInc: () {
                      SellCubit.get(context).incQuantity(context);
                    },
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              if (SellCubit.get(context).sides.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Choose side expenses (if you used it only)"),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<SellCubit, SellState>(
                      builder: (context, state) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return QuantityRow(
                              text:
                                  "(${SellCubit.get(context).sides[i].usedQuantity}) ${SellCubit.get(context).sides[i].side?.name}",
                              onDec: () {
                                SellCubit.get(context).decSideUsedQuantity(i);
                              },
                              onInc: () {
                                SellCubit.get(context).incSideUsedQuantity(i);
                              },
                            );
                          },
                          separatorBuilder: (context, i) => SizedBox(
                            height: 10,
                          ),
                          itemCount: SellCubit.get(context).sides.length,
                        );
                      },
                    ),
                  ],
                ),
              SizedBox(
                height: 25,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.number,
                text: "Any extra expenses (Delivery or anything)",
                onSaved: (value) {
                  if (value!.isNotEmpty)
                    SellCubit.get(context).extra = int.parse(value);
                },
              ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<SellCubit, SellState>(
                builder: (context, state) {
                  if (state is LoadingSellState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    );
                  } else {
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
