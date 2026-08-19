class AppConstants {
  // Subscription Plans
  static const String freePlan = "FREE";

  // Trial Plan
  static const String freeTrialPlan = "Free Trial";
  static const int freeTrialDays = 5;

// Paid Plans
  static const String monthlyPlan = "MONTHLY";
  static const String yearlyPlan = "YEARLY";
  static const String quarterlyPlan = "QUARTERLY";
  static const String halfYearlyPlan = "HALF_YEARLY";

  // Member Limits
  static const int freeMemberLimit = 20;
  static const int unlimitedMembers = -1;

  // Subscription Pricing

// Monthly
  static const double monthlyPrice = 249;
  static const double monthlyOriginalPrice = 499;
  static const int monthlyDurationMonths = 1;
  static double get monthlySavings => monthlyOriginalPrice - monthlyPrice;
  static const String razorpayMonthlyPaymentLink = "https://rzp.io/rzp/SkDBeFm";

// Quarterly
  static const double quarterlyPrice = 699;
  static const double quarterlyOriginalPrice = 1497;
  static const int quarterlyDurationMonths = 3;
  static double get quarterlySavings => quarterlyOriginalPrice - quarterlyPrice;

// Half-Yearly
  static const double halfYearlyPrice = 1299;
  static const double halfYearlyOriginalPrice = 2994;
  static const int halfYearlyDurationMonths = 6;
  static double get halfYearlySavings => halfYearlyOriginalPrice - halfYearlyPrice;

// Yearly
  static const double yearlyPrice = 1899;
  static const double yearlyOriginalPrice = 5000;
  static const int yearlyDurationMonths = 12;
  static double get yearlySavings => yearlyOriginalPrice - yearlyPrice;



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

  //More functionality Related

  // static const String supportEmail = "support@gymmanagerpro.in";
  static const String supportEmail = "gym.manager.haldwani@gmail.com";
 // static const String featureRequestEmail = "features@gymmanagerpro.in";
  static const String featureRequestEmail = "gym.manager.haldwani@gmail.com";
  // static const String supportPhone = "+91XXXXXXXXXX";
  static const String supportPhone = "+917579220114";
  static const String businessHours = "Monday - Saturday\n9:00 AM - 7:00 PM";
  static const String appVersion = "1.0.0";


  // Subscripition status

  static const String trialStatus = "trial";
  static const String activeStatus = "active";
  static const String gracePeriodStatus = "gracePeriod";
  static const String restrictedStatus = "restricted";

// MPIN Security
  static const bool enableMpin = true;




}