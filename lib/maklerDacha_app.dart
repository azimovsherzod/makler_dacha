import '../../../../constans/imports.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MaklerdachaApp extends StatefulWidget {
  @override
  _MaklerdachaAppState createState() => _MaklerdachaAppState();
}

class _MaklerdachaAppState extends State<MaklerdachaApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()..initProfile()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          fontFamily: 'Montserrat',
        ),
        debugShowCheckedModeBanner: false,
        title: 'Dacha Makler',
        initialRoute: Routes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        navigatorKey: rootNavigatorKey,
      ),
    );
  }
}
