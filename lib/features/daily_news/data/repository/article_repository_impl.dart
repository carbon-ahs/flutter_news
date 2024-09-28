import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_apps/core/constants/constants.dart';
import 'package:flutter_apps/core/resources/data_state.dart';
import 'package:flutter_apps/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:flutter_apps/features/daily_news/data/models/article.dart';
import 'package:flutter_apps/features/daily_news/domain/entities/article.dart';
import 'package:flutter_apps/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  ArticleRepositoryImpl(this._newsApiService);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticle() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          type: DioExceptionType.unknown, // potential Bug
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
