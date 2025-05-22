import 'package:dio/dio.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() => _instance;

  final String baseUrl = 'http://192.168.0.102:8000';
  final Dio _dio = Dio();

  Future<Response> getMutualFunds({
    int? page,
    int? limit,
    String? query,
  }) async {
    try {
      final queryParams = {
        'page': page ?? 1,
        'limit': limit ?? 10,
        if (query != null && query.isNotEmpty) 'query': query,
      };

      final response = await _dio.get(
        '$baseUrl/mutual-funds',
        queryParameters: queryParams,
      );
      return response;
    } on DioError catch (e) {
      throw Exception('Failed to load mutual fund data: ${e.message}');
    }
  }

  Future<Response> getHistoricalNav({
    required String schemeCode,
    Map<String, dynamic>?
    timeframe, // example: {"start_date": "01-01-2025", "end_date": "20-05-2025"}
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/mutual-funds/$schemeCode/historical-nav',
        data: timeframe ?? {},
      );
      return response;
    } on DioError catch (e) {
      throw Exception('Failed to fetch historical NAV: ${e.message}');
    }
  }

  // POST /mutual-funds/{scheme_code}/chart
  Future<Response> getNavChartData({
    required String schemeCode,
    Map<String, dynamic>? timeframe,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/mutual-funds/$schemeCode/chart',
        data: timeframe ?? {},
      );
      return response;
    } on DioError catch (e) {
      throw Exception('Failed to fetch NAV chart data: ${e.message}');
    }
  }
}
