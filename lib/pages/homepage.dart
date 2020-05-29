import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:imdb/Models/movie.dart';
import 'package:imdb/providers/search_list_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchData = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget _buildMovieList(List<Movie> list, String error) {
    if (list.length == 0) {
      return Expanded(
        child: Center(
            child: error != '' ? Text(error) : Text('Go do a search!!!!!')),
      );
    }
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 20),
                      child: Container(
                        height: 140,
                        width: 100,
                        child: OverflowBox(
                          alignment: Alignment.bottomCenter,
                          child: Image.network(
                            list[index].posterURL,
                          ),
                          maxWidth: 120,
                          minHeight: 0,
                          minWidth: 0,
                          maxHeight: 160,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              list[index].title,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Genre : ${list[index].genre}",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              softWrap: true,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  list[index].imdbRatings.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                ),
                                RatingBar(
                                  initialRating: list[index].imdbRatings / 2,
                                  direction: Axis.horizontal,
                                  itemSize: 25,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.deepOrange,
                                  ),
                                  glow: true,
                                  glowColor: Colors.orange,
                                  ignoreGestures: true,
                                  tapOnlyMode: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchResultProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
              height: height,
              width: width,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppBar(
                      primary: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(
                          width: 1,
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.blue.shade50,
                      elevation: 0,
                      title: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "e.g Movie Name",
                            helperText: "Movie Name",
                            labelText: "Search",
                          ),
                          controller: _searchData,
                          validator: (value) {
                            if (value.isEmpty || value == null) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            color: Colors.black,
                            onPressed: () {
                              if (_formKey.currentState.validate())
                                provider.getSearchList(_searchData.text);
                            })
                      ],
                    ),
                  ),
                  provider.loading
                      ? Expanded(child: Center(child: Text('Loading....')))
                      : _buildMovieList(provider.list, provider.error),
                ],
              )),
        ),
      ),
    );
  }
}
