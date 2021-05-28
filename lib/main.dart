
import 'package:apk_route_map/pages/home_page.dart';
import 'package:apk_route_map/pages/login_page.dart';
import 'package:apk_route_map/preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreference prefs = new UserPreference();
  await prefs.initPrefs();
  runApp(appRouteMap());
}


class appRouteMap extends StatelessWidget {
  var colors = const Color(0xff1f418b);
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('en', 'US'), const Locale('es', 'ES')],
        debugShowCheckedModeBanner: false,
        title: 'Somos JP',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
        },
        theme: ThemeData(
            primaryColor: colors, accentColor: Colors.deepPurpleAccent),
      ),
    );
  }
}
