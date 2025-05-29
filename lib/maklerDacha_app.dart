import '../../../../constans/imports.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MaklerdachaApp extends StatefulWidget {
  @override
  _MaklerdachaAppState createState() => _MaklerdachaAppState();
}

class _MaklerdachaAppState extends State<MaklerdachaApp> {
  Future<String>? _initialRoute;

  @override
  void initState() {
    super.initState();
    _initialRoute = getInitialRoute();
  }

  Future<String> getInitialRoute() async {
    final box = Hive.box('profileBox');
    final isLoggedIn = box.get('isLoggedIn', defaultValue: false);
    if (isLoggedIn) {
      return Routes.homePage; // Foydalanuvchi tizimga kirgan bo'lsa
    } else {
      return Routes.registerPage; // Foydalanuvchi tizimga kirmagan bo'lsa
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initialRoute,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          print("❌ Xatolik yuz berdi: ${snapshot.error}");
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Xatolik yuz berdi: ${snapshot.error}'),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(
                create: (_) => ProfileProvider()..initProfile()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dacha Makler',
            initialRoute: snapshot.data,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            navigatorKey: rootNavigatorKey,
          ),
        );
      },
    );
  }
}
