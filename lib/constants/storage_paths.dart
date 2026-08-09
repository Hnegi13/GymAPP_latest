class StoragePaths {
  /// Gym Payment QR
  static String paymentQr(String gymUid) =>
      "gyms/$gymUid/payment/qr.png";

  /// Gym Logo
  static String gymLogo(String gymUid) =>
      "gyms/$gymUid/logo/logo.png";

  /// Trainer Photo
  static String trainerPhoto(
      String gymUid,
      String trainerId,
      ) =>
      "gyms/$gymUid/trainers/$trainerId.jpg";

  /// Gallery Images
  static String galleryImage(
      String gymUid,
      String imageName,
      ) =>
      "gyms/$gymUid/gallery/$imageName";

  /// Documents
  static String document(
      String gymUid,
      String fileName,
      ) =>
      "gyms/$gymUid/documents/$fileName";
}