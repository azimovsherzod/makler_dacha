import '../../constans/imports.dart';

class NetworkImageShimmer extends StatelessWidget {
  final String imageUrl;
  final BoxFit boxFit;
  final double? width;
  final double? height;
  final Alignment alignment;

  const NetworkImageShimmer({
    super.key,
    required this.imageUrl,
    this.boxFit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    Uri uri = Uri.tryParse(url) ?? Uri();
    return uri.hasScheme && uri.hasAuthority;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: isValidUrl(imageUrl)
            ? FancyShimmerImage(
                imageUrl: imageUrl,
                shimmerBaseColor: Colors.grey.shade300,
                shimmerHighlightColor: Colors.grey.shade100,
                boxFit: boxFit,
                alignment: alignment,
                errorWidget: Icon(Icons.error),
              )
            : Icon(Icons.error));
  }
}
