import 'constans/imports.dart';

class MaklerdachaApp extends StatelessWidget {
  const MaklerdachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider()..initProfile(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dacha Makler',
        initialRoute: Routes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        navigatorKey: rootNavigatorKey,
      ),
    );
  }
}
