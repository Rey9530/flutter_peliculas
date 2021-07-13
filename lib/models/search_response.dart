import 'dart:convert';

import 'package:flutter_peliculas/models/models.dart';

class SearResponse {
  SearResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movies> results;
  int totalPages;
  int totalResults;

  factory SearResponse.fromJson(String str) =>
      SearResponse.fromMap(json.decode(str));

  factory SearResponse.fromMap(Map<String, dynamic> json) => SearResponse(
        page: json["page"],
        results:
            List<Movies>.from(json["results"].map((x) => Movies.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
