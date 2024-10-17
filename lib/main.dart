import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home_screen.dart';
import 'package:singleeat/office/bloc/coupon_list_bloc.dart';
import 'package:singleeat/office/bloc/manager_bloc.dart';
import 'package:singleeat/office/bloc/store_bloc.dart';
import 'package:singleeat/office/bloc/store_list_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ManagerBloc>(
            create: (BuildContext context) => ManagerBloc(),
          ),
          BlocProvider<StoreListBloc>(create: (BuildContext context) => StoreListBloc()),
          BlocProvider<StoreBloc>(create: (BuildContext context) => StoreBloc()),
          BlocProvider<CouponListBloc>(create: (BuildContext context) => CouponListBloc()),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // TRY THIS: Try running your application with "flutter run". You'll see
              // the application has a purple toolbar. Then, without quitting the app,
              // try changing the seedColor in the colorScheme below to Colors.green
              // and then invoke "hot reload" (save your changes or press the "hot
              // reload" button in a Flutter-supported IDE, or press "r" if you used
              // the command line to start the app).
              //
              // Notice that the counter didn't reset back to zero; the application
              // state is not lost during the reload. To reset the state, use hot
              // restart instead.
              //
              // This works for code too, not just values: Most code changes can be
              // tested with just a hot reload.
              colorSchemeSeed: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
              useMaterial3: true,
            ),
            home: HomeScreen(title: 'Flutter Demo Home Page')));
  }
}
