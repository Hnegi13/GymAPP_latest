import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../utils/app_constants.dart';


class PaymentService {

  late Razorpay razorpay;

  Function(String)? _onSuccess;
  Function(String)? _onFailure;

  PaymentService() {

    razorpay = Razorpay();

    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      handlePaymentSuccess,
    );

    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      handlePaymentError,
    );

    razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      handleExternalWallet,
    );
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {

    print("Payment Success");
    print(response.paymentId);

    _onSuccess?.call(
      response.paymentId ?? "",
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {

    print("Payment Failed");
    print(response.message);

    _onFailure?.call(
      response.message ?? "Payment Failed",
    );
  }

  void handleExternalWallet(
      ExternalWalletResponse response) {

    print("External Wallet");

    print(response.walletName);
  }

  void dispose() {
    razorpay.clear();
  }


  void openCheckout({
    required String name,
    required String description,
    required double amount,
    required String email,
    required String contact,
    required Function(String) onSuccess,
    required Function(String) onFailure,
  }) {

    _onSuccess = onSuccess;
    _onFailure = onFailure;

    var options = {
      'key': AppConstants.razorpayTestKey,
      'amount': (amount * 100).toInt(), // Razorpay accepts amount in paise
      'name': name,
      'description': description,
      'currency': 'INR',
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'method': {
        'upi': true,
        'card': true,
        'netbanking': true,
        'wallet': true,
      },
      'theme': {
        'color': '#673AB7',
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print("Razorpay Error: $e");
    }
  }
}