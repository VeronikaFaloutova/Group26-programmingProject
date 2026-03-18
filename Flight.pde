class Flight {
  String flDate;
  String carrier;
  String flightNum;
  String origin;
  String originCity;
  String dest;
  String destCity;

  int crsDepTime;
  float depTime;
  int crsArrTime;
  float arrTime;

  float cancelled;
  float diverted;
  float distance;

  Flight(String flDate, String carrier, String flightNum,
         String origin, String originCity,
         String dest, String destCity,
         int crsDepTime, float depTime,
         int crsArrTime, float arrTime,
         float cancelled, float diverted, float distance) {

    this.flDate = flDate;
    this.carrier = carrier;
    this.flightNum = flightNum;
    this.origin = origin;
    this.originCity = originCity;
    this.dest = dest;
    this.destCity = destCity;
    this.crsDepTime = crsDepTime;
    this.depTime = depTime;
    this.crsArrTime = crsArrTime;
    this.arrTime = arrTime;
    this.cancelled = cancelled;
    this.diverted = diverted;
    this.distance = distance;
  }

  String getStatus() {
    if (cancelled == 1) {
      return "Cancelled";
    } else if (diverted == 1) {
      return "Diverted";
    } else {
      return "Normal";
    }
  }

  String getFlightCode() {
    return carrier + flightNum;
  }

  String formatTime(float t) {
    if (Float.isNaN(t)) {
      return "--";
    }

    int timeValue = int(t);
    String s = str(timeValue);

    while (s.length() < 4) {
      s = "0" + s;
    }

    return s;
  }

  String getShortCities() {
    String text = originCity + " -> " + destCity;

    if (text.length() > 28) {
      return text.substring(0, 28) + "...";
    }

    return text;
  }
}
