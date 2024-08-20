import 'package:android_muzik/screens/email_sign_in_screen/utils/email_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../providers/loading_provider.dart';
import '../../widgets/loading_widget.dart';

class EmailSingInScreen extends StatefulWidget {
  const EmailSingInScreen({super.key});

  static String routeName = '/email_signin_screen';

  @override
  State<EmailSingInScreen> createState() => _EmailSingInScreenState();
}

class _EmailSingInScreenState extends State<EmailSingInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    final LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context);
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        title: Text(
          'Continue with email',
          style: TextStyle(
            color: textHeadingColor,
            fontSize: screenWidth(context) * 0.06,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: textHeadingColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              TextFormField(
                decoration: formInputDecoration('Email', 'Enter your email'),
                cursorColor: textHeadingColor,
                style: TextStyle(color: textHeadingColor),
                controller: _emailController,
                readOnly: isAuthenticating,
                onTapOutside: (value) {
                  loadingProvider.setIsObscureText(true);
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              TextFormField(
                decoration:
                    formInputDecoration('Password', 'Enter your password')
                        .copyWith(
                  suffixIcon: loadingProvider.isObscureIconVisible
                      ? IconButton(
                          onPressed: () {
                            loadingProvider.setIsObscureText(
                                !loadingProvider.isObscureText);
                          },
                          icon: Icon(
                            loadingProvider.isObscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: textSubHeadingColor,
                          ),
                        )
                      : null,
                ),
                cursorColor: textHeadingColor,
                style: TextStyle(color: textHeadingColor),
                controller: _passwordController,
                readOnly: isAuthenticating,
                obscureText: loadingProvider.isObscureText,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    loadingProvider.setIsObscureIconVisible(true);
                  } else {
                    loadingProvider.setIsObscureIconVisible(false);
                  }
                },
                onTapOutside: (value) {
                  loadingProvider.setIsObscureText(true);
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAuthenticating = true;
                  });
                  emailSignUp(
                      context, _emailController.text, _passwordController.text);
                  setState(() {
                    isAuthenticating = false;
                  });
                },
                style: registerButtonStyle(
                  context,
                  yellowColor,
                  yellowColor,
                ),
                child: isAuthenticating
                    ? LoadingWidget(color: blackColor)
                    : Text(
                        loadingProvider.isRegister ? 'Register' : 'Open',
                        style: TextStyle(
                          color: blackColor,
                          fontSize: screenWidth(context) * 0.045,
                          // fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              SizedBox(height: screenHeight(context) * 0.015),
              ElevatedButton(
                style: registerButtonStyle(
                  context,
                  Colors.transparent,
                  yellowColor,
                ),
                onPressed: () {
                  loadingProvider.setIsRegister(!loadingProvider.isRegister);
                },
                child: Text(
                  loadingProvider.isRegister ? 'Already' : 'Create',
                  style: TextStyle(
                    color: yellowColor,
                    fontSize: screenWidth(context) * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
