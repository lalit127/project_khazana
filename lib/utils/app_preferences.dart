import 'dart:convert';
import 'package:practical_khazana/models/mutual_fund_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static final Future<SharedPreferences> appPref =
      SharedPreferences.getInstance();

  static var accessToken = 'accessToken';
  static var attemptCount = 'attemptCount';

  static Future<int?> getAttemptCount() async {
    return getIntFromSF(attemptCount);
  }

  static Future<void> incrementAttemptCount() async {
    final currentCount = await getAttemptCount();
    final newCount = currentCount != null ? currentCount + 1 : 1;
    await addIntToSF(attemptCount, newCount);
  }

  static Future<void> saveJsonToPrefs(String mKey, dynamic mValue) async {
    final mPref = await appPref;
    final jsonString = jsonEncode(mValue);
    final base64String = base64Encode(utf8.encode(jsonString));
    await mPref.setString(mKey, base64String);
  }

  static Future<dynamic> getJsonFromPrefs(String mKey) async {
    final mPref = await appPref;
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      final jsonString = utf8.decode(base64Decode(base64String));
      return jsonDecode(jsonString);
    }
    return null;
  }

  Future<void> addStringToSF(String mKey, String mValue) async {
    final mPref = await appPref;
    final base64String = base64Encode(utf8.encode(mValue));
    await mPref.setString(mKey, base64String);
  }

  static Future<void> addStringListToSF(
    String mKey,
    List<String> mValueList,
  ) async {
    final mPref = await appPref;
    final base64StringList =
        mValueList.map((item) => base64Encode(utf8.encode(item))).toList();
    await mPref.setStringList(mKey, base64StringList);
  }

  static Future<void> saveMutualFundToWatchList(
    List<MutualFundData> mValueList,
    String mKey,
  ) async {
    final mPref = await appPref;

    final base64StringList =
        mValueList.map((item) {
          final jsonString = jsonEncode(item.toJson());
          final base64String = base64Encode(utf8.encode(jsonString));
          return base64String;
        }).toList();

    await mPref.setStringList(mKey, base64StringList);
  }

  static Future<List<MutualFundData>> getMutualFundWatchList(
    String mKey,
  ) async {
    final mPref = await appPref;
    final base64StringList = mPref.getStringList(mKey) ?? [];

    return base64StringList.map((base64String) {
      final jsonString = utf8.decode(base64Decode(base64String));
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return MutualFundData.fromJson(jsonMap);
    }).toList();
  }

  static Future<void> removeMutualFundFromWatchList(
    MutualFundData item,
    String mKey,
  ) async {
    final existingList = await getMutualFundWatchList(mKey);

    existingList.removeWhere((fund) => fund.schemeName == item.schemeName);

    await saveMutualFundToWatchList(existingList, mKey);
  }

  static Future<List<String>> getStringListValuesSF(String mKey) async {
    final mPref = await appPref;
    final base64StringList = mPref.getStringList(mKey) ?? [];
    final originalStringList =
        base64StringList
            .map((item) => utf8.decode(base64Decode(item)))
            .toList();
    return originalStringList;
  }

  Future<String?> getStringFromSF(String mKey) async {
    final mPref = await appPref;
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return utf8.decode(base64Decode(base64String));
    }
    return null;
  }

  static Future<void> addIntToSF(String mKey, int mValue) async {
    final mPref = await appPref;
    final base64String = base64Encode(utf8.encode(mValue.toString()));
    await mPref.setString(mKey, base64String);
  }

  static Future<int?> getIntFromSF(String mKey) async {
    final mPref = await appPref;
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return int.tryParse(utf8.decode(base64Decode(base64String)));
    }
    return null;
  }

  static Future<void> addDoubleToSF(String mKey, double mValue) async {
    final mPref = await appPref;
    final base64String = base64Encode(utf8.encode(mValue.toString()));
    await mPref.setString(mKey, base64String);
  }

  static Future<double?> getDoubleFromSF(String mKey) async {
    final mPref = await appPref;
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return double.tryParse(utf8.decode(base64Decode(base64String)));
    }
    return null;
  }

  Future<void> addBoolToSF(String mKey, bool mValue) async {
    final mPref = await appPref;
    final base64String = base64Encode(utf8.encode(mValue.toString()));
    await mPref.setString(mKey, base64String);
  }

  Future<bool?> getBoolFromSF(String mKey) async {
    final mPref = await appPref;
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return utf8.decode(base64Decode(base64String)) == 'true';
    }
    return null;
  }

  static Future<void> removeToSF(String mKey) async {
    final mPref = await appPref;
    await mPref.remove(mKey);
  }

  static Future<void> clearSharedPreferences() async {
    final mPref = await appPref;
    await mPref.clear();
    // AppPreference.addBoolToSF(AppPreference.isOnBoard, true);
    //AppPreference.addBoolToSF(AppPreference.isPermission, true);
  }
}
