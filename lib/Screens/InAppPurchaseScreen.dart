import 'package:flutterapps/Helper/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapps/model/settings.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutterapps/Helper/ConstantUtil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterapps/ApiHandler/ApiController.dart';
import 'package:connectivity/connectivity.dart';

class InAppPurchaseScreen extends StatefulWidget {
  static String get routeName => '@routes/welcome-page';
  @override
  _InAppPurchaseScreenState createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen>
    with TickerProviderStateMixin {

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<dynamic>? _subscription;
  late final ProductDetails? inAppProduct;
  bool _isAvailable = false;
  SettingsModel? setting;

  @override
  void initState() {
    super.initState();

    getSetting();
  }

  void getSetting() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage("No Internet connection");
      return;
    }

    ApiController().getSettings().then((response) async {
      setting = response.success == true ? response.setting : null;
      _initialize();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Initialize data
  void _initialize() async {
    print('_initialize');

    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      // handle error here.
    });

    initStoreInfo();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //showPending error
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //show error

        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          //show success
          // call api
          String transactionId = purchaseDetails.purchaseID!;
          String amount = inAppProduct!.price;

          EasyLoading.show(status: 'loading...');
          ApiController().setAsProUser(transactionId, amount).then((response) async {
            Navigator.pop(context);
            EasyLoading.dismiss();
          });
        }
        if (Platform.isAndroid) {

        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    print(isAvailable);
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
      });
      print('return');
      return;
    }

    //For Testing
    List<String> _kProductIds = [setting!.in_app_purchase_id!];
    ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    print(productDetailResponse.error);

    if (productDetailResponse.error == null) {
      print('no error');

      setState(() {
        _isAvailable = isAvailable;
         List products = productDetailResponse.productDetails;
        print('products');
        print(products.length);

        if (products.length > 0){
           inAppProduct = products.first;
         }
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase',style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/splash.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(1),
                Colors.black.withOpacity(0.7),
              ])),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FadeAnimation(
                    1,
                    Text(
                      "Go Pro for unlimited",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 20,
                ),
                FadeAnimation(
                    1.3,
                    Text(
                      "Get benefits of all video for lifetime with single purchase",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                SizedBox(
                  height: 60,
                ),
                FadeAnimation(
                    1.7,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        onTap: () {
                          if (_isAvailable == true && inAppProduct != null) {
                            PurchaseParam purchaseParam = PurchaseParam(
                                productDetails: inAppProduct!);
                            _inAppPurchase.buyNonConsumable(purchaseParam:
                            purchaseParam);
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Center(
                            child: Text(
                              "Buy Pro",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
                FadeAnimation(
                    1.7,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        onTap: () {
                          print('Restore purchase');
                          _inAppPurchase.restorePurchases();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Restore purchases",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}