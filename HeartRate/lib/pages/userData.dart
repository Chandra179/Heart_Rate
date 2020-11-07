class Heart {
  String tanggal;
  String bpm;

  Heart(
      this.tanggal,
      this.bpm,
      );

  Map<String, dynamic> toJson() => {
    'tanggal': tanggal,
    'bpm' : bpm,
  };
}