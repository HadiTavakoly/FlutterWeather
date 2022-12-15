import 'package:flutter/material.dart';
import '../api/search_api.dart';
import '../models/search_model.dart';
import '../constans.dart';

class SearchPage extends StatefulWidget {
   const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Search> searchData = [];
  String searchText = '';
  String keyword = ' ';
  @override
  void initState() {
    search(keyword).then((value) => searchData = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent.withOpacity(0),
          elevation: 0,
          title: TextField(
            autofocus: true,
            style:  TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Colors.white70,
              ),
              fillColor: const Color(0xff351b70),
              filled: true,
              hintText: 'Search country, city or region',
              hintStyle:  TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    40,
                  ),
                  borderSide: BorderSide.none),
            ),
            onChanged: (value) {
              setState(
                () {
                  if (value.isEmpty) {
                    keyword = ' ';
                  } else {
                    keyword = value;
                  }
                  search(keyword).then((value) => searchData = value);
                },
              );
            },
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: search(keyword),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return searchData.isEmpty
                  ?  Text(
                      'Nothing found',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 3),
                          child: Card(
                            color: const Color(0xff1f0754),
                            child: ListTile(
                              title: Text(
                                '${searchData[index].country.toString()}, ${searchData[index].region.toString()}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                searchData[index].name.toString(),
                                style:  TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  searchData[index].name.toString(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
