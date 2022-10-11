class AccidentData {
  int avalancheId;
  DateTime date;
  int dateQuality;
  String hydrologicalYear;
  String canton;
  String locationName;
  double xCoordinate;
  double yCoordinate;
  int coordinatesQuality;
  int elevation;
  String? aspect;
  int? inclination;
  int? dangerLevel;
  int numberDead;
  int numberCaught;
  int numberFullyBuried;
  String activity;

  AccidentData(
      this.avalancheId,
      this.date,
      this.dateQuality,
      this.hydrologicalYear,
      this.canton,
      this.locationName,
      this.xCoordinate,
      this.yCoordinate,
      this.coordinatesQuality,
      this.elevation,
      this.aspect,
      this.inclination,
      this.dangerLevel,
      this.numberDead,
      this.numberCaught,
      this.numberFullyBuried,
      this.activity);

  AccidentData.fromList(List<dynamic> items)
      : this(
          items[0],
          DateTime.parse(items[1]),
          items[2],
          items[3],
          items[4],
          items[5],
          items[6],
          items[7],
          items[8],
          items[9],
          items[10],
          items[11],
          items[12],
          items[13],
          items[14],
          items[15],
          items[16],
        );

  @override
  String toString() {
    return 'AccidentData{avalancheId: $avalancheId, date: $date, dateQuality: $dateQuality, hydrologicalYear: $hydrologicalYear, canton: $canton, locationName: $locationName, xCoordinate: $xCoordinate, yCoordinate: $yCoordinate, coordinatesQuality: $coordinatesQuality, elevation: $elevation, aspect: $aspect, inclination: $inclination, dangerLevel: $dangerLevel, numberDead: $numberDead, numberCaught: $numberCaught, numberFullyBuried: $numberFullyBuried, activity: $activity}';
  }
}

enum Canton {
  AG,
  AI,
  AR,
  BE,
  BL,
  BS,
  FR,
  GE,
  GL,
  GR,
  JU,
  LU,
  NE,
  NW,
  OW,
  SG,
  SH,
  SO,
  SZ,
  TG,
  TI,
  UR,
  VD,
  VS,
  ZG,
  ZH,
}

enum Aspect {
  N,
  NNO,
  NO,
  ONO,
  O,
  OSO,
  SO,
  SSO,
  S,
  SSW,
  SW,
  WSW,
  W,
  WNW,
  NW,
  NNW,
}
