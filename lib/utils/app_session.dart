class AppSession {
  // Whether the current session is a demo/admin session.
  static bool isDemoMode = false;

  // Gym ID currently being used by the app.
  static String? currentGymId;

  // Start a demo/admin session.
  static void startDemoSession({
    required String gymId,
  }) {
    isDemoMode = true;
    currentGymId = gymId;
  }

  // Start a normal Firebase user session.
  static void startNormalSession({
    required String gymId,
  }) {
    isDemoMode = false;
    currentGymId = gymId;
  }

  // Clear the current session.
  static void clearSession() {
    isDemoMode = false;
    currentGymId = null;
  }
}