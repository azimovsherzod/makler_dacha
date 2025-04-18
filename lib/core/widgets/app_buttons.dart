import '../../constans/imports.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.textStyle,
    this.onPressed, // Используем onPressed вместо onTap
    this.style,
    this.icon,
    this.color,
    this.textcolor,
    this.height,
    this.width,
    this.iconPositionLeft = false,
    this.itemsAlignment = MainAxisAlignment.center,
  });

  final String text;
  final VoidCallback? onPressed; // Переименовали onTap в onPressed
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final Widget? icon;
  final Color? color;
  final Color? textcolor;
  final double? height;
  final double? width;
  final bool iconPositionLeft;
  final MainAxisAlignment itemsAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPressed, // Теперь передаем onPressed
        style: style ??
            ElevatedButton.styleFrom(
              backgroundColor: color ?? AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: const BorderSide(
                  color: AppColors.textGrey,
                  width: 0.1,
                  style: BorderStyle.solid,
                ),
              ),
              elevation: 0,
            ),
        child: Row(
          mainAxisAlignment: itemsAlignment,
          children: [
            if (iconPositionLeft && icon != null) icon!,
            if (iconPositionLeft && icon != null) const SizedBox(width: 8),
            if (text.isNotEmpty)
              Text(
                text,
                style: textStyle ?? const TextStyle(color: Colors.white),
              ),
            if (!iconPositionLeft && icon != null) const SizedBox(width: 8),
            if (!iconPositionLeft && icon != null) icon!,
          ],
        ),
      ),
    );
  }
}
