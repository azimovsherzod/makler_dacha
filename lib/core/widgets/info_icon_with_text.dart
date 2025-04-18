import '../../constans/imports.dart';

class InfoIconWithText extends StatelessWidget {
  final String icon;
  final String text;

  const InfoIconWithText({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 20,
          width: 20,
          placeholderBuilder: (context) => const Icon(
            Icons.error,
            size: 20,
            color: Colors.red,
          ),
        ),
        const Gap(4),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
