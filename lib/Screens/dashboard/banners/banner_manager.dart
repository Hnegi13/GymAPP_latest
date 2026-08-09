import 'dart:async';

import 'package:flutter/material.dart';

import '../../../modal/banner_model.dart';
import '../../../services/subscription_guard_service.dart';
import '../../../services/subscription_service.dart';
import '../../../utils/banner_config.dart';
import 'banner_router.dart';
import 'banner_type.dart';

class BannerManager extends StatefulWidget {
  const BannerManager({super.key});

  @override
  State<BannerManager> createState() => _BannerManagerState();
}

class _BannerManagerState extends State<BannerManager> {

  int currentBannerIndex = 0;
  List<BannerModel> activeBanners = [];
  Timer? bannerTimer;

  @override
  void initState() {
    super.initState();
    loadBanners();
  }


  Future<void> loadBanners() async {

    activeBanners = await getActiveBanners();

    if (!mounted) return;
    setState(() {});
    startBannerRotation();
  }


  void startBannerRotation() {

    bannerTimer?.cancel();

    if (activeBanners.length <= 1) {
      return;
    }

    bannerTimer = Timer.periodic(
      BannerConfig.rotationDuration,
          (timer) {

        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {

          currentBannerIndex =
              (currentBannerIndex + 1) %
                  activeBanners.length;

        });

      },
    );
  }


  @override
  Widget build(BuildContext context) {

    if (activeBanners.isEmpty) {
      return const SizedBox.shrink();
    }

    final banner =
    activeBanners[currentBannerIndex];

    return FutureBuilder<Map<String, dynamic>?>(
      future: getSubscriptionDetails(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final subscription = snapshot.data!;

        final planName =
            subscription["plan"] ?? "";

        final endDate =
        subscription["endDate"];

        String validTill = "";

        if (endDate != null) {
          validTill =
          endDate.toDate().toString().split(" ")[0];
        }

        return BannerRouter(

          bannerType: banner.type,

          daysRemaining: 0,

          planName: planName,

          validTill: validTill,

        );

      },
    );

  }

  Future<Map<String, dynamic>?> getSubscriptionDetails() async {
    final subscriptionService = SubscriptionService();
    return await subscriptionService.getSubscription();
  }

  Future<List<BannerModel>> getActiveBanners() async {

    List<BannerModel> banners = [];

    // Subscription Banner
    final status =
    await SubscriptionGuardService()
        .getSubscriptionStatus();
    print("Subscription Status : $status");
    switch (status) {
      case SubscriptionStatus.trial:
        banners.add(
          const BannerModel(
            type: BannerType.trial,
            category: BannerCategory.subscription,
            enabled: true,
            priority: 100,
          ),
        );

        break;

      case SubscriptionStatus.active:

        banners.add(
          const BannerModel(
            type: BannerType.activePlan,
            category: BannerCategory.subscription,
            enabled: true,
            priority: 100,
          ),
        );

        break;

      case SubscriptionStatus.gracePeriod:

        banners.add(
          const BannerModel(
            type: BannerType.gracePeriod,
            category: BannerCategory.subscription,
            enabled: true,
            priority: 100,
          ),
        );

        break;

      case SubscriptionStatus.restricted:

        banners.add(
          const BannerModel(
            type: BannerType.expired,
            category: BannerCategory.subscription,
            enabled: true,
            priority: 100,
          ),
        );

        break;
    }

    // Configured Banners
    banners.addAll(
      BannerConfig.activeBanners.where(
            (e) => e.enabled,
      ),
    );

    print("Active Banner Count : ${banners.length}");

    return banners;
  }

}