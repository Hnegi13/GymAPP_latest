import 'package:flutter/material.dart';
import 'promotional/referral_banner.dart';
import 'banner_type.dart';
import 'info/announcement_banner.dart';
import 'info/maintenance_banner.dart';
import 'info/offer_banner.dart';
import 'subscription/trial_banner.dart';
import 'subscription/active_plan_banner.dart';
import 'subscription/grace_period_banner.dart';
import 'subscription/expired_banner.dart';

class BannerRouter extends StatelessWidget {

  final BannerType bannerType;
  final int daysRemaining;
  final String planName;
  final String validTill;

  const BannerRouter({
    super.key,
    required this.bannerType,
    this.daysRemaining = 0,
    this.planName = "",
    this.validTill = "",

  });

  @override
  Widget build(BuildContext context) {

    switch (bannerType) {

      case BannerType.trial:
        return TrialBanner(
          daysRemaining: daysRemaining,
        );

      case BannerType.activePlan:

        return ActivePlanBanner(
          planName: planName,
          validTill: validTill,
        );

      case BannerType.gracePeriod:

        return GracePeriodBanner(
          daysRemaining: daysRemaining,
        );

      case BannerType.expired:

        return const ExpiredBanner();

      case BannerType.offer:

        return const OfferBanner();

      case BannerType.maintenance:

        return const MaintenanceBanner();

      case BannerType.announcement:

        return const AnnouncementBanner();

      case BannerType.referral:

        return const ReferralBanner();


      default:

        return const SizedBox.shrink();

    }

  }

}