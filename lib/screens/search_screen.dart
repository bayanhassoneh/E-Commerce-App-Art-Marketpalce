import 'package:art_marketplace/providers/search_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchEditingController = TextEditingController();
  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(44.0),
          child: CupertinoNavigationBar(middle: Text('search')),
        ),

        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                controller: _searchEditingController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'search artworks or artists',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
                onFieldSubmitted: searchProvider.performsearch,
              ),
              TabBar(
                tabs: [
                  Tab(text: 'artworks'),
                  Tab(text: 'users'),
                ],
              ),
              Expanded(child: TabBarView(children: [])),
            ],
          ),
        ),
      ),
    );
  }
}
