
class PaymentQrInfo {
  final String upiId;
  final String merchantName;
  final String upiPaymentUri;

  const PaymentQrInfo({
    required this.upiId,
    required this.merchantName,
    required this.upiPaymentUri,
  });
}