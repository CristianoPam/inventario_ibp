import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventario_ibp/app/routes.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return MaterialApp.router(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        
supportedLocales: const [Locale('pt', 'BR')],
      title: 'invetario_flutter',
      theme: ThemeData(
          // fontFamily: 'COMIC',
          useMaterial3: true,
            
          colorScheme: ColorScheme.fromSwatch( 
            backgroundColor:Colors.white               
              ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.black),
          )),
      debugShowCheckedModeBanner: false,
        routerConfig: ref.watch(routerProvider),
      );
    });
  }
}
