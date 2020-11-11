class Heart {
  String tanggal;
  String bpm;
  int myicon;

  Heart(
      this.tanggal,
      this.bpm,
      this.myicon,
      );

  Map<String, dynamic> toJson() => {
    'tanggal': tanggal,
    'bpm' : bpm,
    'icon' : myicon,
  };
}