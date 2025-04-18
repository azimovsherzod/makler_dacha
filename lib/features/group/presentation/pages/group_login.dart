import '../../../../constans/imports.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 2) {
      newText = newText.substring(0, 2) + ' ' + newText.substring(2);
    }
    if (newText.length > 6) {
      newText = newText.substring(0, 6) + ' ' + newText.substring(6);
    }
    if (newText.length > 9) {
      newText = newText.substring(0, 9) + ' ' + newText.substring(9);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class GroupLogin extends StatelessWidget {
  const GroupLogin({super.key});

  // Future<void> sendSmsCode(
  //   BuildContext context,
  //   String phone_number,
  // ) async {
  //   try {
  //     final response = await Dio().post(
  //       baseUrl,
  //       data: {"phone_number": phone_number, "telegram_id": phone_number},
  //       options: Options(
  //         headers: {'Content-Type': 'application/json'},
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('SMS отправлено!')),
  //       );
  //       Get.toNamed(Routes.verificationCodePage,
  //           arguments: {'phone_number': phone_number});
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Ошибка: ${response.data['message']}')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Ошибка соединения: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final phoneCt = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 8, 19),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(LocalImages.logosTelegram),
            const Gap(70),
            Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                maxLength: 12,
                controller: phoneCt,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneNumberFormatter(),
                  LengthLimitingTextInputFormatter(13),
                ],
                decoration: InputDecoration(
                  prefixText: "+998 ",
                  prefixStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 2.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 12) {
                    return 'Phone number must be exactly 12 characters';
                  }
                  return null;
                },
              ),
            ),
            const Gap(20),
            AppButton(
              text: "Next",
              color: AppColors.primaryColor,
              onPressed: () async {
                // if (_formKey.currentState!.validate()) {
                //   final phone = '+998${phoneCt.text.replaceAll(' ', '')}';
                //   await sendSmsCode(context, phone);
                // }
                Get.toNamed(
                  Routes.verificationCodePage,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
