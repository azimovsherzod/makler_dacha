import '../../../../constans/imports.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final String time;
  final bool isSentByUser;
  final bool isSeen;

  const MessageWidget({
    Key? key,
    required this.message,
    required this.time,
    this.isSentByUser = false,
    this.isSeen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentByUser ? AppColors.primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isSentByUser ? Radius.circular(12) : Radius.zero,
            bottomRight: isSentByUser ? Radius.zero : Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: isSentByUser ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSentByUser ? Colors.white70 : Colors.black54,
                  ),
                ),
                if (isSentByUser) ...[
                  SizedBox(width: 8),
                  SvgPicture.asset(
                    LocalIcons.seen,
                    height: 10,
                    color: isSeen ? Colors.blue : Colors.white70,
                  )
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
