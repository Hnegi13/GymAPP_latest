import 'package:url_launcher/url_launcher.dart';

class RazorPaymentLinkService {

  Future<bool> openPaymentLink(String paymentLink) async {
    final uri = Uri.parse(paymentLink);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }

    return false;
  }
}