class AppConstants {
  static const int maxAffection = 1000;
  static const int dailyAffectionLimit = 100;

  static const List<int> milestoneThresholds = [
    25,
    50,
    75,
    100,
    125,
    150,
    175,
    200,
    250,
    300,
    350,
    400,
    450,
    500,
    550,
    600,
    650,
    700,
    750,
    800,
    850,
    900,
    950,
    1000
  ];

  static const int shortTermMemoryLimit = 15;
  static const int mediumTermMemoryLimit = 50;

  static const List<int> focusDurations = [25, 30, 45];

  static const String idleWhiteNoise = 'idle';
  static const String rainWhiteNoise = 'rain';
  static const String cafeWhiteNoise = 'cafe';
}
