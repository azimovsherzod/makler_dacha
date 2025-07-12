import '../../../../../constans/imports.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top blue background
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            color: AppColors.primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(150, 120, 0, 0),
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildLoginForm(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 12,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                  PhoneNumberInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixText: "+998 ",
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixStyle: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 2.0),
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
              const Gap(16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: AppColors.textGrey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const Gap(12),
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              activeColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
            const Text(
              "Remember me",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        const Gap(16),
        AppButton(
          text: "Log In",
          color: AppColors.primaryColor,
          onPressed: () async {
            final authProvider = context.read<AuthProvider>();

            if (_phoneController.text.trim().isEmpty ||
                _passwordController.text.isEmpty) {
              Get.snackbar("Xatolik", "Telefon raqami va parolni kiriting!",
                  backgroundColor: Colors.red);
              return;
            }

            bool success = await authProvider.login(
              _phoneController.text.trim(),
              _passwordController.text,
            );

            if (success) {
              Get.snackbar("Success", "Login successful!",
                  backgroundColor: Colors.green);
              Get.offAllNamed(Routes.maklerHome);
            } else {
              Get.snackbar("Error", "Incorrect phone or password",
                  backgroundColor: Colors.red);
            }
          },
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?",
                style: TextStyle(color: Colors.black)),
            TextButton(
              onPressed: () {
                Get.offNamedUntil(Routes.registerPage, (_) => false);
              },
              child: Text(
                "Sign Up",
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
        const Gap(12),
        const Divider(),
        const Gap(8),
        ElevatedButton.icon(
          onPressed: () {
            // Google login function
          },
          icon: SvgPicture.asset(
            LocalImages.google,
            width: 24,
            height: 24,
          ),
          label: const Text(
            "Continue with Google",
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            elevation: 1,
          ),
        ),
      ],
    );
  }
}
