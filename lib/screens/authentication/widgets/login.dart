import 'package:flutter/material.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/widgets/custom_btn.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool showPassword = true;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool _isFormValidated() {
    final FormState form = formState.currentState;
    return form.validate();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
boxShadow: [
  BoxShadow(
    color: Colors.grey.withOpacity(.5),
    blurRadius: 10,

  )
],
borderRadius: BorderRadius.circular(20)
      ),
      child: Form(
        key: formState,
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.withOpacity(.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: userController.email,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email_outlined),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Email"),
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Please enter a valid email';
                        } else
                          return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.withOpacity(.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: userController.password,
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            showPassword = !showPassword;
                          });
                        }, icon: Icon(Icons.visibility_off_outlined)),
                          icon: Icon(Icons.lock),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Password"),
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Please enter a valid password';
                        } else
                          return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: CustomButton(
                bgColor: Colors.blueAccent,
                  text: "Login", onTap: (){
                    if(_isFormValidated()){
                      userController.signIn();
                    }
              }),
            )
          ],
        ),
      ),
    );
  }
}