import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:w_utils/w_utils.dart';

enum WAdEnum {
  loaded,
  loadedFailed,
  showAdFailed,
  showing,
}

abstract class WAd {
  WAd({
    this.maxFailedLoadAttempts = 3,
    this.testDevice,
    required this.adUnitId,
  });

  final int maxFailedLoadAttempts;
  final String? testDevice;
  final String adUnitId;
  static AdRequest? _defaultRequest;

  static AdRequest getDefaultRequest() {
    _defaultRequest ??= const AdRequest(
      keywords: <String>['foo', 'bar'],
      contentUrl: 'http://foo.com/bar.html',
      nonPersonalizedAds: true,
    );

    return _defaultRequest!;
  }

  Future createAd();
  Future showAd();
}

class WRewardedAd extends WAd {
  WRewardedAd({
    maxFailedLoadAttempts = 3,
    testDevice,
    required adUnitId,
  }) : super(
            adUnitId: adUnitId,
            maxFailedLoadAttempts: maxFailedLoadAttempts,
            testDevice: testDevice);

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numLoadAttempts = 0;

  @override
  Future<WAdEnum> createAd({
    AdRequest? request,
  }) async {
    final _request = request ?? WAd.getDefaultRequest();
    return WFutureUtils.createFuture(({required reject, required resolve}) {
      RewardedInterstitialAd.load(
          adUnitId: adUnitId,
          request: _request,
          rewardedInterstitialAdLoadCallback:
              RewardedInterstitialAdLoadCallback(
            onAdLoaded: (RewardedInterstitialAd ad) {
              _rewardedInterstitialAd = ad;
              _numLoadAttempts = 0;
              resolve(WAdEnum.loaded);
            },
            onAdFailedToLoad: (LoadAdError error) {
              _rewardedInterstitialAd = null;
              _numLoadAttempts += 1;
              if (_numLoadAttempts < maxFailedLoadAttempts) {
                createAd(request: request);
              } else {
                resolve(WAdEnum.loadedFailed);
              }
            },
          ));
    });
  }

  @override
  Future showAd({
    AdRequest? request,
    VoidCallback? onShow,
    VoidCallback? onDismiss,
    VoidCallback? onFailedToShow,
    VoidCallback? onEarnedReward,
  }) async {
    return WFutureUtils.createFuture(({required reject, required resolve}) {
      if (_rewardedInterstitialAd == null) {
        reject('Warning: attempt to show rewarded interstitial before loaded.');
        return;
      }

      _rewardedInterstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
          if (onShow != null) {
            onShow();
          }
        },
        onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
          ad.dispose();
          createAd(request: request);
          if (onDismiss != null) {
            onDismiss();
          }
        },
        onAdFailedToShowFullScreenContent:
            (RewardedInterstitialAd ad, AdError error) {
          ad.dispose();
          createAd(request: request);
          if (onFailedToShow != null) {
            onFailedToShow();
          }
        },
      );

      _rewardedInterstitialAd!.setImmersiveMode(true);
      _rewardedInterstitialAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        if (onEarnedReward != null) {
          onEarnedReward();
        }
      });
      _rewardedInterstitialAd = null;

      resolve(WAdEnum.showing);
    });
  }
}
