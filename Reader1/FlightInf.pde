class Flight {

  String date;
  String airline;
  String flightNumber;

  String origin;
  String originCity;
  String originState;

  String dest;
  String destCity;
  String destState;

  String depTime;
  String schedDepTime;
  String schedArrTime;
  String arrTime;
  String extra1;
  String extra2;

  boolean diverted;
  boolean cancelled;
  int distance;

  Flight(
    String date, String airline, String flightNumber,
    String origin, String originCity, String originState,
    String dest, String destCity, String destState,
    String schedDep, String dep, String schedArr,
    String arr, String extra1, String extra2,
    boolean diverted, boolean cancelled, int distance
  ) {
    this.date = date;
    this.airline = airline;
    this.flightNumber = flightNumber;

    this.origin = origin;
    this.originCity = originCity;
    this.originState = originState;

    this.dest = dest;
    this.destCity = destCity;
    this.destState = destState;

    this.schedDepTime = schedDep;
    this.depTime = dep;
    this.schedArrTime = schedArr;
    this.arrTime = arr;

    this.extra1 = extra1;
    this.extra2 = extra2;

    this.diverted = diverted;
    this.cancelled = cancelled;
    this.distance = distance;
  }
}
