import 'package:flutter/material.dart';
import 'package:flutterapps/Helper/ConstantUtil.dart';
import 'package:flutterapps/model/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutterapps/Screens/LoginScreen.dart';
import 'package:flutterapps/ApiHandler/ApiController.dart';
import 'package:flutterapps/model/UserModel.dart';
import 'package:flutterapps/Screens/InAppPurchaseScreen.dart';
import 'package:flutterapps/Helper/SharedPrefs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:open_mail_app/open_mail_app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  SettingsModel? setting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    getSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black26, Colors.black])),
              child: Container(
                width: double.infinity,
                height: 250.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: FadeInImage(
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            placeholder: AssetImage('assets/splash.jpg'),
                            image: NetworkImage(user?.picture ??
                                "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg")),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        user?.name ?? "Loading",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        user?.email ?? "Loading",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              ListTile(
                  leading: Icon(Icons.shop, color: Colors.black),
                  title: Text('Go Premium',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (context) => InAppPurchaseScreen(),
                        fullscreenDialog: true));
                    // in app purchase
                  }),
              ListTile(
                  leading: Icon(Icons.shop_two_rounded, color: Colors.black),
                  title: Text('Restore in app purchases',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    // in app purchase
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (context) => InAppPurchaseScreen(),
                        fullscreenDialog: true));
                  }),
              ListTile(
                  leading: Icon(Icons.info, color: Colors.black),
                  title: Text('About us',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    _launchURL(ConstantUtil.aboutUs);
                  }),
              setting?.facebook?.isNotEmpty == true ?
              ListTile(
                  leading:
                      Image.asset('assets/social/facebook.png', height: 25),
                  title: Text('Follow on Facebook',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    _launchURL(setting!.facebook!);
                  })
              :
              Container(),
              setting?.youtube?.isNotEmpty == true ?
              ListTile(
                  leading: Image.asset(
                    'assets/social/youtube.png',
                    height: 25,
                  ),
                  title: Text('Follow on Youtube',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    _launchURL(setting!.youtube!);
                  })
              :
              Container(),
              setting?.instagram?.isNotEmpty == true ?
              ListTile(
                  leading:
                      Image.asset('assets/social/instagram.png', height: 25),
                  title: Text('Follow on Instagram',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    _launchURL(setting!.instagram!);
                  }):
              Container(),
              ListTile(
                  leading: Icon(Icons.policy_rounded, color: Colors.black),
                  title: Text('Privacy policy',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    _launchURL(ConstantUtil.privacyPolicyUrl);
                  }),
              ListTile(
                  leading: Icon(Icons.logout, color: Colors.black),
                  title: Text('Logout',
                      style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  onTap: () {
                    SharedPrefs().setUserLoggedIn(false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        ModalRoute.withName("/Home"));
                  }),
            ],
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getProfile() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage("No Internet connection");
      return;
    }

    EasyLoading.show(status: 'loading...');
    ApiController().getUserProfile().then((response) async {
      user = response.success == true ? response.user : null;
      print(response.user);
      setState(() {});
      EasyLoading.dismiss();
    });
  }

  void getSetting() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage("No Internet connection");
      return;
    }

    ApiController().getSettings().then((response) async {
      setting = response.success == true ? response.setting : null;
      setState(() {});
    });
  }

  void showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void openContactUsEmail() async {
    EmailContent email = EmailContent(
      to: [
        ConstantUtil.contactUsEmail,
      ],
      subject: 'Hello!',
      body: 'Please enter your query',
    );

    OpenMailAppResult result = await OpenMailApp.composeNewEmailInMailApp(
        nativePickerTitle: 'Select email app to compose', emailContent: email);
    if (!result.didOpen && !result.canOpen) {
      showNoMailAppsDialog(context);
    } else if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        builder: (_) => MailAppPickerDialog(
          mailApps: result.options,
          emailContent: email,
        ),
      );
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
