import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterapps/Helper/userProfileManager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutterapps/model/UserModel.dart';
import 'package:flutterapps/Helper/ConstantUtil.dart';

class AdHelper {

  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return AdmobConstants.bannerAdUnitIdForAndroid;
  //   } else if (Platform.isIOS) {
  //     return AdmobConstants.bannerAdUnitIdForiOS;
  //   } else {
  //     throw new UnsupportedError('Unsupported platform');
  //   }
  // }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.interstitialAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.interstitialAdUnitIdForiOS;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

class BannerAds extends StatefulWidget {
  const BannerAds({Key? key}) : super(key: key);

  @override
  _BannerAdsState createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  @override

  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  static bool _isBannerAdReady = false;

  void initState() {
    super.initState();
    if (UserModel().is_premium_user == 0){
      // loadAds();
    }
  }

  Widget build(BuildContext context) {
    return
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: UserModel().is_premium_user == 0 ? _bannerAd.size.height.toDouble() : 0,
          child:  UserModel().is_premium_user == 0 ? AdWidget(ad: _bannerAd): SizedBox(height: 1,),
        ),
      );
  }

  // void loadAds(){
  //   // TODO: Initialize _bannerAd
  //   _bannerAd = BannerAd(
  //     adUnitId: AdHelper.bannerAdUnitId,
  //     request: AdRequest(),
  //     size: AdSize.banner,
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isBannerAdReady = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, err) {
  //         print('Failed to load a banner ad: ${err.message}');
  //         _isBannerAdReady = false;
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   _bannerAd.load();
  // }
}

class InterstitialAds extends StatelessWidget {
  final VoidCallback? onCompletion;

  InterstitialAds({Key? key,this.onCompletion}) : super(key: key);

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void loadInterstitialAd() {
    if (UserProfileManager().user?.is_premium_user == 1){
      onCompletion!();
      return;
    }
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;
          _interstitialAd?.show();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              onCompletion!();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
          print(onCompletion);
          onCompletion!();
        },
      ),
    );
  }
}
