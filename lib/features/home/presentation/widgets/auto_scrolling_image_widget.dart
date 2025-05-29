import '../../../../constans/imports.dart';

class AutoScrollingImageWidget extends StatelessWidget {
  final List<String> images;

  const AutoScrollingImageWidget({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    // Faqat 3 ta rasmni ko'rsatish
    final List<String> imagePaths =
        images.length > 3 ? images.sublist(0, 3) : images;

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: PageView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return const Placeholder();
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "Shahzod Dasdasdaa",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "active",
                        style: TextStyle(color: Colors.green),
                      ),
                      const Gap(5),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
