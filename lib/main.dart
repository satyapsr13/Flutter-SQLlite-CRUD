import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqllite_impl/Data/services/sql_helper.dart';
import 'package:flutter_sqllite_impl/Presentation/Screens/home_screen.dart';
//  import 'package:google_mobile_ads/google_mobile_ads.da`rt';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Logic/block_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SQLHelper.initSQLLiteDB();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);
  await EasyLocalization.ensureInitialized();
  // final secureStorage = SecureStorage();
  final HydratedStorage hydratedStorage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  var blocProviders = await getBlocProviders(hydratedStorage);
  HydratedBlocOverrides.runZoned(() {
    runApp(
      MyApp(
        blocProviders: blocProviders,
      ),
    );
  }, storage: hydratedStorage);
}

class MyApp extends StatelessWidget {
  final List<BlocProvider> blocProviders;

  const MyApp({
    Key? key,
    required this.blocProviders,
  }) : super(key: key);

  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: blocProviders,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(primaryColor: const Color.fromARGB(255, 5, 83, 238)),
          title: 'ManakTech',
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
