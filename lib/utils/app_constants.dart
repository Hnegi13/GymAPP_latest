class AppConstants {
  // Subscription Plans
  static const String freePlan = "FREE";
  static const String monthlyPlan = "MONTHLY";
  static const String yearlyPlan = "YEARLY";

  // Member Limits
  static const int freeMemberLimit = 5;
  static const int unlimitedMembers = -1;

  // Pricing (Launch Offer)
  static const double monthlyPrice = 299;
  static const double yearlyPrice = 3000;

  // Original Pricing
  static const double monthlyOriginalPrice = 499;
  static const double yearlyOriginalPrice = 5000;

  // Payment Status
  static const String paymentFree = "FREE";
  static const String paymentPaid = "PAID";
  static const String paymentPending = "PENDING";
  static const String paymentFailed = "FAILED";

  // Razorpay
  static const String razorpayTestKey = "rzp_test_TDRxJ9jm75A7Ai";
  static const String razorpayLiveKey = "rzp_live_xxxxxxxxx";

  //Subscription Guard Service logic
  static const int subscriptionGraceDays = 3;

}