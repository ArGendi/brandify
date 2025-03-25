import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';

class SidesScreen extends StatefulWidget {
  const SidesScreen({super.key});

  @override
  State<SidesScreen> createState() => _SidesScreenState();
}

class _SidesScreenState extends State<SidesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SidesCubit.get(context).getAllSides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Side expenses"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<SidesCubit, SidesState>(
          builder: (context, state) {
            if (state is LoadingSidesState) {
              return Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              );
            } else {
              return Visibility(
                visible: SidesCubit.get(context).sides.isNotEmpty,
                replacement: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        "assets/animations/request.json",
                        width: 300,
                      ),
                      //SizedBox(height: 20,),
                      Text(
                        "Any side expenses you use in your orders",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                child: ListView.separated(
                  itemBuilder: (context, i) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.shade900,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        SidesCubit.get(context)
                                            .sides[i]
                                            .quantity
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      SidesCubit.get(context)
                                          .sides[i]
                                          .name
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${SidesCubit.get(context).sides[i].price} LE",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                          IconButton(
                            onPressed: () {
                              SidesCubit.get(context).remove(i);
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                          )
                      ],
                    );
                  },
                  separatorBuilder: (context, i) => SizedBox(
                    height: 15,
                  ),
                  itemCount: SidesCubit.get(context).sides.length,
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _AddBottomSheet(context);
        },
        label: Text("Add side expenses"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue.shade900,
      ),
    );
  }

  Future<void> _AddBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: SidesCubit.get(context).formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomTextFormField(
                    text: "Name",
                    onSaved: (value) {
                      SidesCubit.get(context).name = value;
                    },
                    onValidate: (value) {
                      if (value!.isEmpty) {
                        return "Enter name";
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          keyboardType: TextInputType.number,
                          text: "Price",
                          onSaved: (value) {
                            if (value!.isNotEmpty)
                              SidesCubit.get(context).price =
                                  int.parse(value);
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return "Enter price";
                            } else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextFormField(
                          keyboardType: TextInputType.number,
                          text: "Quantity",
                          onSaved: (value) {
                            if (value!.isNotEmpty)
                              SidesCubit.get(context).quantity =
                                  int.parse(value);
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return "Enter quantity";
                            } else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<SidesCubit, SidesState>(
                    builder: (context, state) {
                      if(state is LoadingOneSideState){
                        return Center(child: CircularProgressIndicator(backgroundColor: mainColor,),);
                      }
                      else{
                        return CustomButton(
                          bgColor: Colors.blue.shade900,
                          text: "Add",
                          onPressed: () async {
                            bool done = await SidesCubit.get(context)
                                .onAddSide(context);
                            if (done) Navigator.pop(context);
                          },
                        );
                      }
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
