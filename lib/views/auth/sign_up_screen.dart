import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/auth.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_input.dart';
import '../main_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery, context);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _image != null) {
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods().signUpUser(
        // cartPrice: 0,
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!,
        phone: _phoneController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (res != "success") {
        showSnackBar(res, context);
      } else {
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => MainScreen(),
            ));
      }
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/Logo-removebg-preview.png",
                  height: 150,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 74,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage("assets/icons/3d-fluency-person.png"),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter your name",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 24),
                TextFieldInput(
                  textEditingController: _phoneController,
                  hintText: "Enter phone number",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 24),
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
                  onPressed: signUpUser,
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
                      : Text("SignUp", style: TextStyle(color: Colors.white,fontSize: 22)),
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
                builder: (context) => LoginScreen(),
              ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Do have an account? "),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Login.", style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
