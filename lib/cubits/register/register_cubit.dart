import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/auth_services.dart';
import 'package:tabe3/view/screens/home_screen.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String name;
  late String phone;
  late String password;
  late String confirmPassword;

  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  void onRegister(BuildContext context) async{
    formKey.currentState!.save();
    bool valid = formKey.currentState!.validate();
    if(valid){
      emit(RegisterLoadingState());
      var response = await AuthServices.register("$phone@brandify.com", password);
      if(response.status == Status.success){
        emit(RegisterSuccessState());
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      else{
        emit(RegisterFailState());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data))
        );
      }
    }
  }
}
