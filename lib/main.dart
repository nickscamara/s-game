import 'package:flutter/material.dart';
import 'package:premiumsnake/model/user.dart';
import 'package:premiumsnake/services/route_service.dart';
import 'package:premiumsnake/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game.dart';
import 'menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Bungee"),
      home: MultiProvider(providers: [
        ChangeNotifierProvider<UserService>(
          create: (_) => UserService(),
        ),
        ChangeNotifierProvider<RouteService>(
          create: (_) => RouteService(),
        ),
      ], child: Menu()),
    );
  }
}
