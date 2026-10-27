
enum Mood {
  veryBad(1),
  bad(2),
  okay(3),
  good(4),
  veryGood(5);

  final int id;
  const Mood(this.id);
}

extension MoodFromId on int? {
  Mood? get mood {
    switch (this) {
      case 1: return Mood.veryBad;
      case 2: return Mood.bad;
      case 3: return Mood.okay;
      case 4: return Mood.good;
      case 5: return Mood.veryGood;
      default: return null;
    }
  }
}

extension MoodLabel on Mood? {
  String get label {
    switch (this) {
      case Mood.veryBad: return 'Need\nHelp';
      case Mood.bad: return 'Could Be\nBetter';
      case Mood.okay: return "It's\nFine";
      case Mood.good: return 'Feeling\nGood';
      case Mood.veryGood: return 'Loving\nIt!';
      default: return '--';
    }
  }
}