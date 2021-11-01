
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutterapps/ApiHandler/ApiController.dart';
import 'package:flutterapps/Helper/FormValidator.dart';
import 'package:flutterapps/Screens/TabContainer.dart';
import 'package:flutterapps/Screens/Background.dart';
import 'package:flutterapps/components/rounded_button.dart';
import 'package:flutterapps/components/rounded_input_field.dart';
import 'package:flutterapps/components/rounded_password_field.dart';
import 'package:flutterapps/Screens/OrDivider.dart';
import 'package:flutterapps/components/AlreadyHaveAccountComponent.dart';
import 'package:flutterapps/Screens/LoginScreen.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage>{
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGN UP",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50,color: Colors.white),
              ),

              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                icon: Icons.email ,
                controller: email,
                onChanged: (value) {},
              ),
              RoundedInputField(
                hintText: "Name",
                icon: Icons.person,
                controller: name,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: password,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: confirmPassword,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "SIGN UP",
                press: () => signpBtnClicked(),
              ),
              OrDivider(),
              AlreadyHaveAccountComponent(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signpBtnClicked(){
    if(FormValidator().isTextEmpty(email.text)){
      print("Email is empty");
    }
    if(FormValidator().isTextEmpty(name.text)){
      print("Name is empty");
    }
    else if(FormValidator().isTextEmpty(password.text)){
      print("Password is empty");
    }
    else if(FormValidator().isTextEmpty(confirmPassword.text)){
      print("Confirm Password is empty");
    }
    else if(password.text != confirmPassword.text){
      print("Password does not matched");
    }
    else{
      ApiController().registerUserApi(name.text, email.text, password.text).then((response) async {
        print("Sign up success");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => TabContainer()
            ),
            ModalRoute.withName("/Home")
        );
      });
    }
  }
}

