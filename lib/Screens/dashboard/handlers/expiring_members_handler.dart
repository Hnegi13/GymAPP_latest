import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_service.dart';
import '../../../services/subscription_guard_service.dart';
import '../../subscription_page.dart';
import '../../filtered_members_page.dart';
import '../../../modal/member.dart';

class ExpiringMembersHandler {

static final FirestoreService firestoreService =FirestoreService();
static final SubscriptionGuardService subscriptionGuard =SubscriptionGuardService();


static Future<void> execute(BuildContext context) async {

  if (!await SubscriptionGuardService.checkSubscriptionAccess(
    context,
    featureName: "Expiring Members",
  )) {
    return;
  }
  final List<Member> members = await firestoreService.getExpiringMembers();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FilteredMembersPage(
        title: 'Expiring Members',
        members: members,
        isExpired: false,
      ),
    ),
  );


}



}