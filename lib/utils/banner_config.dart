import '../Screens/dashboard/banners/banner_type.dart';
import '../modal/banner_model.dart';

class BannerConfig {

  static const Duration rotationDuration = Duration(seconds: 5);
  static const List<BannerModel> activeBanners = [

    BannerModel(
      type: BannerType.offer,
      category: BannerCategory.info,
      enabled: false,
      priority: 50,
    ),

    BannerModel(
      type: BannerType.maintenance,
      category: BannerCategory.info,
      enabled: false,
      priority: 40,
    ),

    BannerModel(
      type: BannerType.announcement,
      category: BannerCategory.info,
      enabled: false,
      priority: 30,
    ),

    // Promotional
    BannerModel(
      type: BannerType.referral,
      category: BannerCategory.promotional,
      enabled: false,
      priority: 20,
    ),


  ];

}