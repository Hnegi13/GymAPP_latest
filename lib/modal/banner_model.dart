

import '../Screens/dashboard/banners/banner_type.dart';

enum BannerCategory {

  subscription,

  info,

  promotional,

}

class BannerModel {

  final BannerType type;

  final BannerCategory category;

  final bool enabled;

  final int priority;

  const BannerModel({

    required this.type,

    required this.category,

    required this.enabled,

    required this.priority,

  });

}