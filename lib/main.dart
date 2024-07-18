import 'package:file_management/presentation/blocs/bloc.dart';
import 'package:file_management/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await _checkAndRequestPermissions();

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

Future<void> _checkAndRequestPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
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
