import 'dart:async';
import '../../../../constans/imports.dart';

class AutoScrollingImageCustomWidget extends StatefulWidget {
  final int index;

  const AutoScrollingImageCustomWidget({super.key, required this.index});

  @override
  State<AutoScrollingImageCustomWidget> createState() =>
      _AutoScrollingImageCustomWidgetState();
}

class _AutoScrollingImageCustomWidgetState
    extends State<AutoScrollingImageCustomWidget> {
  late PageController pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        if (!mounted) return;

        setState(() {
          _currentPage++;
          final dacha = context.read<ProfileProvider>().dachas[widget.index];
          final images = dacha.images ?? [];
          if (_currentPage >= (images.length > 3 ? 3 : images.length)) {
            _currentPage = 0;
          }
        });

        if (pageController.hasClients) {
          pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final dacha = profileProvider.dachas[widget.index];
        final images = dacha.images ?? [];
        final showImages = images.length > 3 ? images.sublist(0, 3) : images;

        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.imageViewerPage, arguments: images);
          },
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: showImages.isNotEmpty ? showImages.length : 1,
                  itemBuilder: (context, index) {
                    final imageUrl =
                        showImages.isNotEmpty ? showImages[index] : null;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image,
                                          size: 60, color: Colors.grey),
                                    );
                                  },
                                )
                              : Image.asset(
                                  LocalImages.errorImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300,
                                ),
                          // Gradient overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.35),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Title badge (chap yuqori)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dacha.name.isNotEmpty ? dacha.name : "No Name",
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Status badge (o'ng yuqori)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          dacha.isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            color: dacha.isActive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.check_circle,
                          color: dacha.isActive ? Colors.green : Colors.red,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                // Indicator (pastda markazda)
                if (showImages.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        showImages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.primaryColor
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
