import '../../../../constans/imports.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final List<TextEditingController> _controllers =
      List.generate(5, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  Future<void> _verifyCode() async {
    try {
      final code = _controllers.map((controller) => controller.text).join();
      if (code.length != 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пожалуйста, введите полный код')),
        );
        return;
      }

      final phoneNumber = Get.arguments!['phone_number'];

      print({
        "phone_number": phoneNumber,
        "code": code,
        "telegram_id": phoneNumber
      });
      final response = await _dio.post(
        '$domain/auth/verify-code/',
        data: {
          "phone_number": phoneNumber,
          "code": code,
          "telegram_id": phoneNumber
        },
      );

      if (response.statusCode == 200) {
        print("sms send");
        Get.offAndToNamed(Routes.groupPage);
      }
      if (response.statusCode == 400) {
        print("${response.data['error']}");
      } else {
        print("Error ${response.data['message']}");
      }
    } catch (e) {
      print('test ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = Get.arguments!['phone_number'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
        child: Column(
          children: [
            const Text(
              "Verification Code",
              style: TextStyle(
                  fontSize: 22,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "We have sent a verification code to:",
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(phoneNumber,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Change phone number?",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
            const Gap(20),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (index) => SizedBox(
                    width: 60,
                    height: 60,
                    child: TextFormField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black, // <-- mana shu rangni qora qiling!
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primaryColor, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Gap(40),
            AppButton(
              text: "Verify code",
              color: AppColors.primaryColor,
              onPressed: _verifyCode,
            ),
          ],
        ),
      ),
    );
  }
}
