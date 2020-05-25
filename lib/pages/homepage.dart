import 'package:flutter/material.dart';
import 'package:imdb/Models/movie.dart';
import 'package:imdb/providers/search_list_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchData = TextEditingController();

  Widget _buildMovieList(List<Movie> list) {
    if (list.length == 0) {
      return Center(child: Text('Go do a search!!!!!'));
    }

    return ListView.builder(
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
                        children: <Widget>[
                          Text(
                            list[index].title,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            softWrap: true,
                          ),
                          Text(
                            list[index].year,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            softWrap: true,
                          ),
                          Text(
                            list[index].type,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(width: 2,),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade50,
            elevation: 0,
            title: TextFormField(
              decoration: InputDecoration(
                hintText: "Search here",
              ),
              controller: _searchData,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                color: Colors.black,
                onPressed: () => provider.getSearchList(_searchData.text),
              )
            ],
          ),
          body: Container(
            height: height,
            width: width,
            child: provider.loading
                ? Center(child: Text('Loading....'))
                : _buildMovieList(provider.list),
          ),
        ),
      ),
    );
  }
}
