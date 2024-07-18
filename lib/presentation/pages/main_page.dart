import 'package:file_management/presentation/pages/local_page.dart';
import 'package:file_management/presentation/pages/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF212121), // Cambia a tu color deseado
      statusBarIconBrightness: Brightness.light, // Cambia el color de los iconos de la barra de estado (claro u oscuro)
    ));
  }

  @override
  Widget build(BuildContext context) {

    LocalFileBloc localFileBloc = BlocProvider.of<LocalFileBloc>(context);
    CloudFileBloc cloudFileBloc = BlocProvider.of<CloudFileBloc>(context);

    return SafeArea(
      child: Scaffold(
          body: IndexedStack(
            index: currentPageIndex,
            children: [
              LocalPage(
                localFileBloc: localFileBloc
              ),
              CloudPage(
                cloudFileBloc: cloudFileBloc, 
              ),
            ],
          ),
        bottomNavigationBar: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Local',
                    activeIcon: Icon(Icons.home)
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.cloud_outlined),
                    label: 'Cloud',
                    activeIcon: Icon(Icons.cloud)
                  ),
                ],
                currentIndex: currentPageIndex,
                selectedItemColor: Colors.black,
                onTap: (value) {
                  setState(() {
                    currentPageIndex = value;
                  });
                },
              ),
              AnimatedPositioned(
                bottom: 0,
                left: constraints.maxWidth /
                        2 *
                        (currentPageIndex) + //space of current index
                    (constraints.maxWidth / 6) - // minimize the half of it
                    30,
                duration: const Duration(
                  milliseconds: 100,
                ), // minimize the width of dash
                child: Container(
                  width: 120,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}