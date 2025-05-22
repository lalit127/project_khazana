class NavChartModel {
  String? schemeCode;
  String? schemeName;
  String? latestNav;
  String? lastUpdated;
  List<HistoricalData>? historicalData;

  NavChartModel({
    this.schemeCode,
    this.schemeName,
    this.latestNav,
    this.lastUpdated,
    this.historicalData,
  });

  NavChartModel.fromJson(Map<String, dynamic> json) {
    schemeCode = json['scheme_code'];
    schemeName = json['scheme_name'];
    latestNav = json['latest_nav'];
    lastUpdated = json['last_updated'];
    if (json['historical_data'] != null) {
      historicalData = <HistoricalData>[];
      json['historical_data'].forEach((v) {
        historicalData!.add(new HistoricalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme_code'] = this.schemeCode;
    data['scheme_name'] = this.schemeName;
    data['latest_nav'] = this.latestNav;
    data['last_updated'] = this.lastUpdated;
    if (this.historicalData != null) {
      data['historical_data'] =
          this.historicalData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoricalData {
  String? date;
  double? nav;
  double? dayChange;

  HistoricalData({this.date, this.nav, this.dayChange});

  HistoricalData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    nav = json['nav'];
    dayChange = json['dayChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['nav'] = this.nav;
    data['dayChange'] = this.dayChange;
    return data;
  }
}
