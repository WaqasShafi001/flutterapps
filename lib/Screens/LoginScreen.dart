import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapps/ApiHandler/ApiController.dart';
import 'package:flutterapps/Helper/FormValidator.dart';
import 'package:flutterapps/Screens/TabContainer.dart';
import 'package:flutterapps/Screens/Background.dart';
import 'package:flutterapps/components/rounded_button.dart';
import 'package:flutterapps/components/rounded_input_field.dart';
import 'package:flutterapps/components/rounded_password_field.dart';
import 'package:flutterapps/components/AlreadyHaveAccountComponent.dart';
import 'package:flutterapps/Screens/OrDivider.dart';
import 'package:flutterapps/Screens/SocalIcon.dart';
import 'package:flutterapps/Screens/SignUpScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutterapps/ApiHandler/ApiResponseModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity/connectivity.dart';

class LoginScreen extends StatefulWidget {

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GoogleSignInAccount? _currentUser;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ],
  );

  @override
  void initState() {
    late StreamSubscription<ConnectivityResult> _connectivitySubscription;

    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        socialSignIn('google', _currentUser?.displayName ?? 'Anonymous', _currentUser?.id ?? "", _currentUser?.email ?? "");
      }
      else{
        EasyLoading.dismiss();
      }
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showMessage('No internet');
      }
      else{
        showMessage('Internet connected');
      }
    });
  }

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
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50,color: Colors.white),
              ),

              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                icon: Icons.email ,
                controller: email,
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: password,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "LOGIN",
                press: () => loginBtnClicked(),
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAccountComponent(
                login: true,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignupPage();
                      },
                    ),
                  );
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/social/facebook.png",
                    press: _handleFacebookLogin
                  ),
                  SocalIcon(
                    iconSrc: "assets/social/apple.png",
                    press: _handleAppleSignIn
                  ),
                  SocalIcon(
                    iconSrc: "assets/social/google.png",
                    press: _handleGoogleSignIn
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    print('try');
    try {
      print('trying login');
      EasyLoading.show(status: 'loading...');
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleAppleSignIn() async{
    EasyLoading.show(status: 'loading...');

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:
        'com.aboutyou.dart_packages.sign_in_with_apple.example',
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
      // TODO: Remove these if you have no need for them
      nonce: 'example-nonce',
      state: 'example-state',
    );

    print(credential);

    if (credential != null){
        socialSignIn('apple', credential.familyName ?? 'Anonymous', credential.userIdentifier!, credential.email!);
    }
    else{
      EasyLoading.dismiss();
    }

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'flutter-sign-in-with-apple-example.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        if (credential.givenName != null)
          'firstName': credential.givenName!,
        if (credential.familyName != null)
          'lastName': credential.familyName!,
        'useBundleId':
        Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
        if (credential.state != null) 'state': credential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );
    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    print(session);
  }

  void socialSignIn(String type, String name, String socialID, String email){
    print(socialID);
    ApiController().socialLoginApi(name, type, socialID, email).then((response) async {
      handleResponse(response);
      EasyLoading.dismiss();
    });
  }

  Future<void> _handleFacebookLogin() async{
    EasyLoading.show(status: 'loading...');

    final fb = FacebookLogin();

// Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
      // Logged in

      // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken!;
        print('Access token: ${accessToken.token}');

        // Get profile data
        final profile = await fb.getUserProfile();
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await fb.getUserEmail();
        // But user can decline permission

        socialSignIn('fb', profile!.name ?? 'Anonymous', profile.userId, email!);
        break;
      case FacebookLoginStatus.cancel:
      // User cancel log in
        EasyLoading.dismiss();
        break;
      case FacebookLoginStatus.error:
      // Log in failed
        print('Error while log in: ${res.error}');
        EasyLoading.dismiss();
        break;
    }
  }

  void handleResponse(ApiResponseModel response){
    if (response.success == true){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => TabContainer()
          ),
          ModalRoute.withName("/Home")
      );
    }
    else{;
      showMessage(response.message!);
    }
  }

  void loginBtnClicked() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage("No Internet connection");
      return;
    }

    if(FormValidator().isTextEmpty(email.text)){
      print("Email is empty");
    }
    else if(FormValidator().isTextEmpty(password.text)){
      print("Password is empty");
    }
    else{
      EasyLoading.show(status: 'loading...');

      ApiController().loginApi(email.text, password.text).then((response) async {
        print("Login success");
        handleResponse(response);
        EasyLoading.dismiss();
      });
    }
  }

  void showMessage(String message){
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

