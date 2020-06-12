import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:whoami/constants.dart';

class InterstitialAdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('InterstitialAd Page'),
      ),
    );
  }
}

class BannerAdPage extends StatefulWidget {
  @override
  _BannerAdPageState createState() => _BannerAdPageState();
}

class _BannerAdPageState extends State<BannerAdPage> {

  BannerAd myBanner;
  String myAdId = 'ca-app-pub-6276155927126955/5076266624';
  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: useTestId ? BannerAd.testAdUnitId : myAdId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  BannerAd buildLargeBannerAd() {
    return BannerAd(
        adUnitId: useTestId ? BannerAd.testAdUnitId : myAdId,
        size: AdSize.largeBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner
              ..show(
                  anchorType: AnchorType.top,
                  anchorOffset: MediaQuery.of(context).size.height * 0.15);
          }
        });
  }

  @override
  void initState() {
    super.initState();

    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    myBanner = buildBannerAd()..load();
    //myBanner = buildLargeBannerAd()..load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}