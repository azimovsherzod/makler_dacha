import '../../constans/imports.dart';

void showLoadingAlert() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
}

void dismissLoadingAlert() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}
