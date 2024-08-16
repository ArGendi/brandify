import 'package:flutter/material.dart';
import 'package:tabe3/cubits/last_months/last_months_cubit.dart';

class LastMonthsScreen extends StatelessWidget {
  const LastMonthsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الأشهر السابقة"),
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemBuilder:(context, i){
            return Container();
          }, 
          separatorBuilder: (context, i) => SizedBox(height: 15,), 
          itemCount: LastMonthsCubit.get(context).months.length,
        ),
      ),
    );
  }
}