import '../../../../constans/imports.dart';

class ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;
  const ProfileInfoItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textGreyDark,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textGreyDark,
            ),
          ),
        ],
      ),
    );
  }
}
