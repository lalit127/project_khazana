class MutualFundData {
  String? schemeCode;
  String? schemeName;
  String? imageUrl;
  double? currentNav;
  bool? isBookMarked;
  Returns? returns;

  // String? isinDivReinvestment;

  MutualFundData({
    this.schemeCode,
    this.schemeName,
    this.currentNav,
    this.imageUrl,
    this.isBookMarked = false,
    this.returns,
    // this.isinGrowth,
    // this.isinDivReinvestment,
  });

  MutualFundData.fromJson(Map<String, dynamic> json) {
    schemeCode = json['scheme_code'];
    schemeName = json['scheme_name'];
    imageUrl = json['imageUrl'];
    currentNav = json['current_nav'];
    isBookMarked = json['isBookMarked'] ?? false;
    returns =
        json['returns'] != null ? Returns.fromJson(json['returns']) : null;
    // isinGrowth = json['isinGrowth'];
    // isinDivReinvestment = json['isinDivReinvestment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheme_code'] = this.schemeCode;
    data['scheme_name'] = this.schemeName;
    data['imageUrl'] = this.imageUrl;
    data['currentNav'] = this.currentNav;
    data['isBookMarked'] = this.isBookMarked;
    if (this.returns != null) {
      data['returns'] = this.returns!.toJson();
    }
    // data['isinGrowth'] = this.isinGrowth;
    // data['isinDivReinvestment'] = this.isinDivReinvestment;
    return data;
  }

  List<MutualFundData> fromDecodedJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MutualFundData.fromJson(json)).toList();
  }
}

class Returns {
  double? i1d;
  double? d1y;
  double? n3y;
  double? d5y;

  Returns({this.i1d, this.d1y, this.n3y, this.d5y});

  Returns.fromJson(Map<String, dynamic> json) {
    i1d = json['1d'];
    d1y = json['1y'];
    n3y = json['3y'] ?? 0.0;
    d5y = json['5y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1d'] = this.i1d;
    data['1y'] = this.d1y;
    data['3y'] = this.n3y;
    data['5y'] = this.d5y;
    return data;
  }
}
