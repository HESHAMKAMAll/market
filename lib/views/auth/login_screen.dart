import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:market/views/auth/sign_up_screen.dart';
import '../../controller/auth.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_input.dart';
import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    FocusManager.instance.primaryFocus!.unfocus();
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => MainScreen(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              children: [
                Image.asset(
                  "assets/icons/Logo-removebg-preview.png",
                  height: 150,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 60),
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(500, 45),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                      : Text("Login", style: TextStyle(color: Colors.white,fontSize: 22)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => SignUpScreen(),
              ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Don't have an account? "),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Sign Up.", style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
