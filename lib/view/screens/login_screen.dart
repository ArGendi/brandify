// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/login/login_cubit.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  late Animation<Offset> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400)
    );

    animation = Tween<Offset>(
      begin: Offset(0,-2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutBack)
    );

    Timer(Duration(milliseconds: 200), (){
      controller.forward();
    });

    // String lang = BlocProvider.of<LanguageCubit>(context).lang;
    // BlocProvider.of<PackagesCubit>(context).getPackages(lang);
  }

  @override
  Widget build(BuildContext context) {
    var loginCubit = BlocProvider.of<LoginCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,20,20,20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: animation,
                child: Text(
                  "Tabe3",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: mainColor
                  ),
                )
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Text(
                    "Go follow up your business",//"أدخل وتابع شغلك دلوقتي",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //color: mainColor,
                      //fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: loginCubit.formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          prefix: Icon(
                            Icons.phone_iphone_rounded,
                            color: Colors.grey[600],
                          ),
                          text: "Email Address",
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            loginCubit.email = value.toString();
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email";
                            }
                            else if (!value.contains("@") || !value.contains(".")) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          prefix: Icon(
                            Icons.lock,
                            color: Colors.grey[600],
                          ),
                          text: "Password",
                          obscureText: true,
                          onSaved: (value) {
                            loginCubit.password = value.toString();
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return "Enter your password";
                            }
                            else if(value.length < 8){
                              return "Minimum 8 characters";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        launchUrlString("https://wa.me/+201227701988?text=نسيت الباسورد بتاعي");
                      },
                      child: Text(
                        "Forget password?",
                        style: TextStyle(
                          color: mainColor,
                          //fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      if(state is LoadingState){
                        return const Center(
                          child: CircularProgressIndicator(color: mainColor,),
                        );
                      }
                      else{
                        return CustomButton(
                          text: "Login",
                          onPressed: () {
                            loginCubit.onLogin(context);
                          },
                        );
                      }
                    },
                  ),
                  // const SizedBox(height: 5,),
                  // CustomButton(
                  //   bgColor: Colors.green.shade600,
                  //   text: AppLocalizations.of(context)!.new_registration,
                  //   onPressed: (){
                  //     Navigator.pushNamed(context, registerPath);
                  //   },
                  // ),
                ],
              ),
              // Spacer(),
              // Text(
              //   AppLocalizations.of(context)!.registration_agreement,
              //   style: TextStyle(color: Colors.grey, height: 1),
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pushNamed(context, privacyPolicyPath);
              //   },
              //   child: Text(
              //     AppLocalizations.of(context)!.terms_of_use_and_privacy_policy,
              //     style: TextStyle(
              //       color: mainColor,
              //       //height: 0.1
              //       //fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

}
