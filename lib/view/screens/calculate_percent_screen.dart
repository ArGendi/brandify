import 'package:flutter/material.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';

class CalculatePercentScreen extends StatefulWidget {
  const CalculatePercentScreen({super.key});

  @override
  State<CalculatePercentScreen> createState() => _CalculatePercentScreenState();
}

class _CalculatePercentScreenState extends State<CalculatePercentScreen> {
  int? price;
  int? percent;
  double? total;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculate the precent"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(total != null)
              Text(
                "Price after sale",
                style: TextStyle(
                  color: mainColor
                ),
              ),
              Text(
                total?.toStringAsFixed(1) ?? "",
                style: TextStyle(
                  fontSize: 28,
                  color: mainColor,
                  height: 1
                ),
              ),
              SizedBox(height: 20,),
              Text("Enter product price and discount percent to calculate price after discount", textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      keyboardType: TextInputType.number,
                      text: "Product price", 
                      onSaved: (value){
                        if(value!.isNotEmpty)
                          price = int.parse(value);
                      },
                      onValidate: (value){
                        if(value!.isEmpty){
                          return "Enter price";
                        }
                        else return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: CustomTextFormField(
                      keyboardType: TextInputType.number,
                      text: "Discount percent %", 
                      onSaved: (value){
                        if(value!.isNotEmpty)
                          percent = int.parse(value);
                      },
                      onValidate: (value){
                        if(value!.isEmpty){
                          return "Enter percent";
                        }
                        else return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              CustomButton(
                text: "Calculate", 
                onPressed: (){
                  bool valid = formKey.currentState?.validate() ?? false;
                  if(valid){
                    formKey.currentState?.save();
                    setState(() {
                      total = price! - (price! * (percent! / 100));
                    });
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