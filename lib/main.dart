import 'constans/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive kutubxonasini ishga tushirish
  await Hive.initFlutter();

  // Boxlarni ochish
  if (!Hive.isBoxOpen('profileBox')) {
    await Hive.openBox('profileBox');
  }
  if (!Hive.isBoxOpen('dachaBox')) {
    await Hive.openBox('dachaBox');
  }

  print("✅ Hive muvaffaqiyatli ishga tushirildi va boxlar ochildi.");

  runApp(const MaklerdachaApp());
}
