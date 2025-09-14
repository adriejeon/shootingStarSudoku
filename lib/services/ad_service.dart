import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/constants.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  static AdService get instance => _instance;
  AdService._internal();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  // 배너 광고 로드
  Future<BannerAd?> loadBannerAd() async {
    if (!_isInitialized) await initialize();
    
    _bannerAd = BannerAd(
      adUnitId: AppConstants.testBannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('배너 광고 로드됨');
        },
        onAdFailedToLoad: (ad, error) {
          print('배너 광고 로드 실패: $error');
          ad.dispose();
        },
      ),
    );
    
    await _bannerAd!.load();
    return _bannerAd;
  }

  // 전면 광고 로드
  Future<void> loadInterstitialAd() async {
    if (!_isInitialized) await initialize();
    
    await InterstitialAd.load(
      adUnitId: AppConstants.testInterstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('전면 광고 로드됨');
        },
        onAdFailedToLoad: (error) {
          print('전면 광고 로드 실패: $error');
        },
      ),
    );
  }

  // 전면 광고 표시
  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print('전면 광고 표시됨');
        },
        onAdDismissedFullScreenContent: (ad) {
          print('전면 광고 닫힘');
          ad.dispose();
          _interstitialAd = null;
          // 다음 광고 미리 로드
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('전면 광고 표시 실패: $error');
          ad.dispose();
          _interstitialAd = null;
        },
      );
      
      await _interstitialAd!.show();
    } else {
      print('전면 광고가 로드되지 않음');
    }
  }

  // 보상형 광고 로드
  Future<void> loadRewardedAd() async {
    if (!_isInitialized) await initialize();
    
    await RewardedAd.load(
      adUnitId: AppConstants.testRewardedAdId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('보상형 광고 로드됨');
        },
        onAdFailedToLoad: (error) {
          print('보상형 광고 로드 실패: $error');
        },
      ),
    );
  }

  // 보상형 광고 표시
  Future<bool> showRewardedAd() async {
    if (_rewardedAd == null) {
      print('보상형 광고가 로드되지 않음');
      return false;
    }

    bool rewardEarned = false;
    
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('보상형 광고 표시됨');
      },
      onAdDismissedFullScreenContent: (ad) {
        print('보상형 광고 닫힘');
        ad.dispose();
        _rewardedAd = null;
        // 다음 광고 미리 로드
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('보상형 광고 표시 실패: $error');
        ad.dispose();
        _rewardedAd = null;
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        print('보상 획득: ${reward.amount} ${reward.type}');
        rewardEarned = true;
      },
    );

    return rewardEarned;
  }

  // 광고 정리
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  // 광고 로드 상태 확인
  bool get isBannerAdLoaded => _bannerAd != null;
  bool get isInterstitialAdLoaded => _interstitialAd != null;
  bool get isRewardedAdLoaded => _rewardedAd != null;
}
