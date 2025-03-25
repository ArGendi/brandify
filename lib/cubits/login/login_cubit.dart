import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/auth_services.dart';
import 'package:tabe3/view/screens/home_screen.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String phone;
  late String password;

  LoginCubit() : super(LoginInitial());
  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  void onLogin(BuildContext context) async{
    bool valid = formKey.currentState!.validate();
    if(valid){
      formKey.currentState!.save();
      emit(LoadingState());
      var response = await AuthServices.login(phone, password);
      if(response.status == Status.success){
        emit(SuccessState());
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      else{
        emit(FailState());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Wrong email or password"), backgroundColor: Colors.red,)
        );
      }
    }
  }
}
