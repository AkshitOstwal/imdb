// imdb mini clone app made in flutter for cross platform
// using TMDB API
import 'package:flutter/material.dart';
import 'package:imdb/pages/homepage.dart';
import 'package:imdb/providers/search_list_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: SearchResultProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IMDB',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
