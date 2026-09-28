import 'package:dio/dio.dart';

class QuoteDto {
  final String content;
  final String author;
  const QuoteDto({required this.content, required this.author});
}

class QuotesApi {
  QuotesApi(this._dio);
  final Dio _dio;

  Future<QuoteDto> fetchRandom() async {
    final res = await _dio.get('/quotes/random');
    final data = res.data as Map<String, dynamic>;
    return QuoteDto(
      content: (data['quote'] as String).trim(),
      author: (data['author'] as String).trim(),
    );
  }
}
