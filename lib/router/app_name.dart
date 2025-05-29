import 'package:flutter/cupertino.dart';

import '../constans/imports.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

sealed class AppRoutes {
  AppRoutes._();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return CupertinoPageRoute(
            builder: (context) => const OnBoardingPage(), settings: settings);
      case Routes.homePage:
        return CupertinoPageRoute(
            builder: (context) => HomePage(), settings: settings);
      case Routes.main:
        return CupertinoPageRoute(
            builder: (context) => const MainPage(), settings: settings);
      case Routes.splash:
        return CupertinoPageRoute(
            builder: (context) => const SplashPage(), settings: settings);
      case Routes.listingDetailPage:
        return CupertinoPageRoute(
            builder: (context) {
              final dacha = settings.arguments as DachaModel;
              return ListingDetailPage(
                dacha: dacha,
              );
            },
            settings: settings);
      case Routes.profileDetail:
        return CupertinoPageRoute(
          builder: (context) {
            final dacha = settings.arguments as DachaModel?;
            if (dacha == null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Xatolik"),
                ),
                body: const Center(
                  child: Text(
                    "Dacha ma'lumotlari mavjud emas.",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              );
            }
            print(
                "Card tapped: ${dacha.name}"); // dacha.name qiymatini chop etish
            return ProfileDetail(dacha: dacha);
          },
          settings: settings,
        );
      case Routes.imageViewerPage:
        return CupertinoPageRoute(
            builder: (context) => const ImageViewerPage(), settings: settings);
      case Routes.commentsPages:
        return CupertinoPageRoute(
            builder: (context) => const CommentsPage(), settings: settings);
      case Routes.notificationPage:
        return CupertinoPageRoute(
            builder: (context) => const NotificationPage(), settings: settings);
      case Routes.profilePage:
        return CupertinoPageRoute(
            builder: (context) => ProfilePage(), settings: settings);
      case Routes.chatPage:
        return CupertinoPageRoute(
            builder: (context) => const ChatPage(), settings: settings);
      case Routes.editPage:
        final dacha = settings.arguments as DachaModel? ??
            DachaModel(
                id: 0,
                name: "",
                address: "",
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                deletedAt: DateTime.now(),
                deleted: false,
                isActive: false,
                bedsCount: 0,
                hallCount: 0,
                price: 0,
                description: '',
                phone: '',
                popularPlace: 0,
                clientType: 0,
                facilities: [],
                transactionType: '',
                propertyType: "",
                user: 0,
                images: []);

        return CupertinoPageRoute(
            builder: (context) => EditPage(dacha: dacha), settings: settings);
      case Routes.groupPage:
        return CupertinoPageRoute(
            builder: (context) => const GroupPage(), settings: settings);
      case Routes.rating:
        return CupertinoPageRoute(
            builder: (context) => const Rating(), settings: settings);
      case Routes.loginPage:
        return CupertinoPageRoute(
            builder: (context) => const LoginPage(), settings: settings);
      case Routes.registerPage:
        return CupertinoPageRoute(
            builder: (context) => const RegisterPage(), settings: settings);
      case Routes.groupLogin:
        return CupertinoPageRoute(
            builder: (context) => const GroupLogin(), settings: settings);
      case Routes.infoPage:
        return CupertinoPageRoute(
            builder: (context) => const InfoPage(), settings: settings);
      case Routes.verificationCodePage:
        return CupertinoPageRoute(
            builder: (context) => VerificationCodePage(), settings: settings);
      case Routes.filter:
        final city = settings.arguments as String? ?? 'Unknown';
        return CupertinoPageRoute(builder: (context) => FilterPage(city: city));
      default:
        return null;
    }
  }
}
