import '../../../../constans/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('profileBox');
  await Hive.openBox('dachaBox');
  runApp(MaklerdachaApp());
}
