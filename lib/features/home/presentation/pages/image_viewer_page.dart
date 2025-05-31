import '../../../../constans/imports.dart';

class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({Key? key}) : super(key: key);

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late final List<String> _imagePaths;
  late final PageController _pageController;
  int _currentImageIndex = 0;

  String getFullImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (path.startsWith('/')) {
      return '$domain$path';
    }
    return path;
  }

  bool _isNetwork(String path) =>
      path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('/images/') ||
      path.startsWith('/media/');

  @override
  void initState() {
    super.initState();
    // Get.arguments orqali rasm ro'yxatini oling
    final argImages = Get.arguments;
    if (argImages is List<String>) {
      _imagePaths = argImages;
    } else if (argImages is List) {
      _imagePaths = argImages.map((e) => e.toString()).toList();
    } else {
      _imagePaths = [LocalImages.errorImage];
    }
    _pageController = PageController(initialPage: _currentImageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: SvgPicture.asset(LocalIcons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 100, 12, 0),
            width: 500,
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: PageView.builder(
              itemCount: _imagePaths.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final path = _imagePaths[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _isNetwork(path)
                      ? Image.network(
                          getFullImageUrl(path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            LocalImages.errorImage,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          path,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                );
              },
            ),
          ),
          const Gap(20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                final path = _imagePaths[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentImageIndex = index;
                      _pageController.jumpToPage(index);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 8, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentImageIndex == index
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _isNetwork(path)
                          ? Image.network(
                              getFullImageUrl(path),
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                LocalImages.errorImage,
                                width: 80,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              path,
                              width: 80,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
