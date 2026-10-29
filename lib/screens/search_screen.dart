import 'package:art_marketplace/providers/search_provider.dart';
import 'package:art_marketplace/widgets/post_card.dart';
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
                  labelText: 'search artworks or artists..',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
                onFieldSubmitted: searchProvider.performsearch,
              ),
              TabBar(
                indicatorColor: Colors.deepPurpleAccent,
                labelColor: Colors.deepPurpleAccent,
                tabs: [
                  Tab(text: 'artworks'),
                  Tab(text: 'users'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //tab 1: artworks
                    if (searchProvider.artworksFutur == null)
                      const Center(
                        child: Text(
                          'search for artworks',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    else if (searchProvider.artworksFutur!.isEmpty)
                      const Center(
                        child: Text(
                          'no matching results found',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    else
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: searchProvider.artworksFutur!.length,
                        itemBuilder: (context, index) {
                          final post = searchProvider.artworksFutur![index];
                          return PostCard(post: post);
                        },
                      ),

                    //tab 2: users
                    if (searchProvider.usresFuture == null)
                      const Center(
                        child: Text(
                          'search for users',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    else if (searchProvider.usresFuture!.isEmpty)
                      const Center(
                        child: Text(
                          'no matching results',
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount: searchProvider.usresFuture!.length,
                        itemBuilder: (context, index) {
                          final user = searchProvider.usresFuture![index];
                          return ListTile(
                            minTileHeight: 80,
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: user.profilePicture.isNotEmpty
                                  ? NetworkImage(user.profilePicture)
                                  : const AssetImage(
                                      'assets/images/default_avatar.png',
                                    ),
                            ),
                            //networkImage()+assetImage >>ImageProvider
                            //image.network+image.assets>> widgets of image type
                            title: Text(
                              user.username,
                              style: TextStyle(fontSize: 16),
                            ),

                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 2, 1, 5),
                            ),
                            trailing: Text('trailing'),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/Profile',
                                arguments: user.id,
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
