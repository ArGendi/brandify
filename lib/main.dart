

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/login/login_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/cubits/reports/reports_cubit.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/firebase_options.dart';
import 'package:tabe3/view/screens/products/add_product_screen.dart';
import 'package:tabe3/view/screens/home_screen.dart';
import 'package:tabe3/view/screens/login_screen.dart';
import 'package:tabe3/view/screens/products/products_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => ProductsCubit()),
        BlocProvider(create: (_) => SidesCubit()),
        BlocProvider(create: (_) => AllSellsCubit()),
        BlocProvider(create: (_) => ReportsCubit()),
      ],
      child: MaterialApp(
        title: 'Tabe3',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: mainColor,
            foregroundColor: Colors.white,
            elevation: 5,
            centerTitle: true,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: mainColor,
            foregroundColor: Colors.white,
          )
          //fontFamily: 'times new roman',
        ),
        home: FirebaseAuth.instance.currentUser != null ? HomeScreen() : LoginScreen(),
      ),
    );
  }
}
