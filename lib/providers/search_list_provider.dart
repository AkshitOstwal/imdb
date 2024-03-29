import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Models/movie.dart';

class SearchResultProvider with ChangeNotifier {
  List<Movie> _list = [];
  String _error = '';
  bool _loading = false;
  bool get loading {
    return _loading;
  }

  String get error {
    return _error;
  }

  List<Movie> get list {
    return List.castFrom(_list);
  }

  Future<bool> getSearchList(String data) async {
    _loading = true;
    _list = [];
    _error = '';
    notifyListeners();
    String apikey = 'e23e734d';
    var result =
        await http.get('http://www.omdbapi.com/?apikey=$apikey&s=$data');
    var response = json.decode(result.body);
    print("\n");
    if (response['Response'] == "False") {
      print(response['Error']);
      _error = response['Error'];
      notifyListeners();
      return false;
    } else {
      List<dynamic> _demoList = response['Search'];
      _demoList.forEach((element) async {
        var result = await http.get(
            'http://www.omdbapi.com/?apikey=$apikey&i=${element['imdbID']}');
        var response = json.decode(result.body);
        Movie _demo = Movie();
        _demo.title = element['Title'];
        _demo.imdbID = element['imdbID'];
        _demo.year = element['Year'];
        _demo.type = element['Type'];
        _demo.posterURL = element['Poster'];
        _demo.imdbRatings = double.parse(response['imdbRating']);
        _demo.genre = response['Genre'];
        _list.add(_demo);
        notifyListeners();
      });
      _list.forEach((element) {
        print(element.title);
      });
      _loading = false;
      notifyListeners();
      return true;
    }
  }
}
