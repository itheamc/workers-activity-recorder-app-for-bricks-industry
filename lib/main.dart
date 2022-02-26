import 'package:daily_records_sandip/providers/database_provider.dart';
import 'package:daily_records_sandip/screens/bharai_screen.dart';
import 'package:daily_records_sandip/screens/home_screen.dart';
import 'package:daily_records_sandip/screens/nikashi_screen.dart';
import 'package:daily_records_sandip/screens/pakki_screen.dart';
import 'package:daily_records_sandip/screens/setting_screen.dart';
import 'package:daily_records_sandip/screens/transactions_screen.dart';
import 'package:daily_records_sandip/screens/workers_screen.dart';
import 'package:daily_records_sandip/utils/a_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider())
      ],
      child: MaterialApp(
        title: "Activity Recorder",
        initialRoute: "/",
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (_) => const HomeScreen(),
          MyRoute.setting: (_) => const SettingScreen(),
          MyRoute.workers: (_) => const WorkersScreen(),
          MyRoute.nikashi: (_) => const NikashiScreen(),
          MyRoute.bharai: (_) => const BharaiScreen(),
          MyRoute.pakki: (_) => const PakkiScreen(),
          MyRoute.transactions: (_) => const TransactionScreen(),
        },
      ),
    );
  }
}