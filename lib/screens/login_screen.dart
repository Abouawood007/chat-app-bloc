import 'package:chat_up/cubit/login_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/Custom_button_widget.dart';
import '../widgets/constant_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import 'chat_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  bool hide = true;
  String? email;

  String? password;

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoaded = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMEssage();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      email: email!,
                    )),
          );
          showSnackBar(context, 'Login Success');
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errorMessage);
        }
      },
      child: ModalProgressHUD(
        //باكدج جبتها عشان تعمل circular indicator
        inAsyncCall:
            isLoaded, //circular indicator متغير بيعرفني حالة ال indicator
        child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 75,
                      ),
                      Image.asset(
                        'assets/images/icons8-chat-messages-100.png',
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'Chat up !',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      customTextFormField(
                          onChanged: (data) {
                            email = data;
                          }, // بستقبل الداتا اللي جيه من textFormField
                          hintText: 'Email',
                          prefixIcon: Icons.email,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'It is required to enter Email';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      customTextFormField(
                          onChanged: (data) {
                            password = data;
                          },
                          isPassword: BlocProvider.of<LoginCubit>(context).hide,
                          prefixIcon: Icons.lock,
                          hintText: 'Password',
                          suffixIcon:
                              hide ? Icons.visibility : Icons.visibility_off,
                          suffixFunction: () {
                            BlocProvider.of<LoginCubit>(context)
                                .togglePasswordVisibility();
                            // setState(() {
                            //   hide = !hide;
                            // });
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'you have to enter password';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 75,
                      ),
                      CustomButton(
                          buttonName: 'Log in',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await BlocProvider.of<LoginCubit>(context)
                                  .loginUser(
                                      email: email!, password: password!);
                              // ignore: use_build_context_synchronously
                              //
                              // ignore: use_build_context_synchronously

                            }
                          }),
                      const SizedBox(
                        height: 75,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            'Dont have an account? Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signInFunction() async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
// try {
//   // Code that may throw a Firebase error
//   // For example:
//   await FirebaseFirestore.instance.collection('users').doc('nonexistent').get();
// } catch  (e) {
//   // Handle the error
//   if (e is FirebaseException) {
//     // Firebase error occurred
//     print('Firebase error: ${e.message}');
//   } else {
//     // Other type of error occurred
//     print('Error: $e');
//   }
// }
