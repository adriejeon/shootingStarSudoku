// 광고 서비스 (비활성화)
// import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  static AdService get instance => _instance;
  AdService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 광고 비활성화 - 더미 구현
    _isInitialized = true;
    print('광고 서비스 비활성화됨');
  }

  // 배너 광고 로드 (비활성화)
  Future<dynamic> loadBannerAd() async {
    print('배너 광고 비활성화됨');
    return null;
  }

  // 전면 광고 로드 (비활성화)
  Future<void> loadInterstitialAd() async {
    print('전면 광고 비활성화됨');
  }

  // 전면 광고 표시 (비활성화)
  Future<void> showInterstitialAd() async {
    print('전면 광고 표시 비활성화됨');
  }

  // 보상형 광고 로드 (비활성화)
  Future<void> loadRewardedAd() async {
    print('보상형 광고 비활성화됨');
  }

  // 보상형 광고 표시 (비활성화)
  Future<bool> showRewardedAd() async {
    print('보상형 광고 표시 비활성화됨');
    return false;
  }

  // 광고 정리 (비활성화)
  void dispose() {
    print('광고 서비스 정리됨');
  }

  // 광고 로드 상태 확인 (비활성화)
  bool get isBannerAdLoaded => false;
  bool get isInterstitialAdLoaded => false;
  bool get isRewardedAdLoaded => false;
}
