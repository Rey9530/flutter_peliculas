import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_peliculas/helpers/debouncer.dart';
import 'package:flutter_peliculas/models/models.dart';
import 'package:flutter_peliculas/models/popular_response.dart';
import 'package:flutter_peliculas/models/search_response.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';
  String _apikey = 'c73acda1ba7a0ab0fe617e111502ee4a';
  int _page = 0;
  List<Movies> listMovies = [];
  List<Movies> popularMovies = [];

  Map<int, List<Cast>> listCast = {};

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Movies>> _suggestionStreamControler =
      new StreamController.broadcast();

  Stream<List<Movies>> get suggestonStream =>
      this._suggestionStreamControler.stream;

  MoviesProvider() {
    this.getOnDisplayMovie();
    this.getPopularMovie();
  }

  Future<String> _getJsonData(String endPoint, [int pagina = 1]) async {
    //
    final url = Uri.https(_baseUrl, endPoint, {
      'api_key': this._apikey,
      'language': this._language,
      'page': pagina.toString(),
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovie() async {
    final data = await this._getJsonData('3/movie/now_playing');
    final resp = NowPlayingResponse.fromJson(data);
    this.listMovies = resp.results;
    notifyListeners();
  }

  getPopularMovie() async {
    this._page++;
    print(this._page);
    final data = await this._getJsonData('3/movie/popular', this._page);
    final popularResponse = PopularResponse.fromJson(data);
    this.popularMovies = [...this.popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovideCast(int movieId) async {
    if (listCast.containsKey(movieId)) return listCast[movieId]!;

    final data = await this._getJsonData('3/movie/$movieId/credits');
    final credicResponse = CrediReponse.fromJson(data);
    listCast[movieId] = credicResponse.cast;
    return credicResponse.cast;
  }

  Future<List<Movies>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, "3/search/movie", {
      'api_key': this._apikey,
      'language': this._language,
      'query': query,
    });
    final response = await http.get(url);
    final searResponse = SearResponse.fromJson(response.body);
    return searResponse.results;
  }

  void suggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (query) async {
      final result = await this.searchMovie(query);
      this._suggestionStreamControler.add(result);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
