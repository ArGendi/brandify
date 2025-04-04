import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/ads/ads_cubit.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ads"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Form(
                    key: AdsCubit.get(context).formKey,
                    child: CustomTextFormField(
                      keyboardType: TextInputType.number,
                      text: "Ad cost",
                      onSaved: (value) {
                        if (value!.isNotEmpty) {
                          AdsCubit.get(context).cost = int.parse(value);
                        }
                      },
                      onValidate: (value) {
                        if (value!.isEmpty) {
                          return "Enter ad cost";
                        } else return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Your ad platform ?"),
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<AdsCubit, AdsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(context)
                                    .setPlatform(SocialMediaPlatform.facebook);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AdsCubit.get(context).selectedPlatform ==
                                            SocialMediaPlatform.facebook
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade300),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    size: 30,
                                    color: AdsCubit.get(context).selectedPlatform ==
                                            SocialMediaPlatform.facebook
                                        ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(context)
                                    .setPlatform(SocialMediaPlatform.instagram);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AdsCubit.get(context).selectedPlatform ==
                                            SocialMediaPlatform.instagram
                                        ? Colors.red.shade700
                                        : Colors.grey.shade300),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    size: 30,
                                    color: AdsCubit.get(context).selectedPlatform ==
                                            SocialMediaPlatform.instagram
                                        ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10,),
                  BlocBuilder<AdsCubit, AdsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(context)
                                    .setPlatform(SocialMediaPlatform.tiktok);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AdsCubit.get(context).selectedPlatform ==
                                            SocialMediaPlatform.tiktok
                                        ? Colors.black
                                        : Colors.grey.shade300),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.tiktok,
                                    size: 30,
                                    color: AdsCubit.get(context).selectedPlatform ==
                                            SocialMediaPlatform.tiktok
                                        ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(context)
                                    .setPlatform(SocialMediaPlatform.other);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AdsCubit.get(context).selectedPlatform ==
                                            SocialMediaPlatform.other
                                        ? mainColor
                                        : Colors.grey.shade300),
                                child: Center(
                                  child: Text(
                                    "Other",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AdsCubit.get(context).selectedPlatform ==
                                              SocialMediaPlatform.other
                                          ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  BlocBuilder<AdsCubit, AdsState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: AdsCubit.get(context).getDate(),
                        onPressed: () async {
                          var date = await showDatePicker(
                            context: context,
                            initialDate: AdsCubit.get(context).date,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(AdsCubit.get(context).date.year + 1),
                          );
                          if (date != null) {
                            AdsCubit.get(context).setDate(date);
                          }
                        },
                        bgColor: Colors.grey.shade700,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            CustomButton(
              text: "Add", 
              onPressed: (){
                AdsCubit.get(context).onAdd(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
