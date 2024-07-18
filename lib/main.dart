import 'package:file_management/presentation/blocs/bloc.dart';
import 'package:file_management/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocalFileBloc()),
        BlocProvider(create: (_) => CloudFileBloc()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        primaryColor: Colors.black, 
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/main_pages',
      routes: {
        '/main_pages': (_) => const MainPage(),
      },
    );
  }
}
