import '../../../../constans/imports.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100,
            height: 2,
            color: AppColors.textGrey,
          ),
          const Text("Today", style: TextStyle(fontSize: 20)),
          Container(
            width: 100,
            height: 2,
            color: AppColors.textGrey,
          ),
        ],
      ),
    );
  }
}
