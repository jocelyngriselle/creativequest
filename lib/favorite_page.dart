import 'package:flutter/material.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  final List<IdeaType> ideaTypes;

  FavoritesPage({Key key, this.ideaTypes}) : super(key: key);

  @override
  _FavoritesPageState createState() {
    return _FavoritesPageState();
  }
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<String>> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = _prefs.then((SharedPreferences prefs) {
      return (prefs.getStringList('creative_quest_favorites') ?? []);
    });
  }

  Future<void> _removeFromFavorites(int index) async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites =
        prefs.getStringList('creative_quest_favorites') ?? [];
    favorites.removeAt(index);

    setState(() {
      _favorites = prefs
          .setStringList("creative_quest_favorites", favorites)
          .then((bool success) {
        return favorites;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("IdeaTypesPage");
    print(widget.ideaTypes);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
          title:
              Text('Favorites', style: Theme.of(context).textTheme.headline5),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: FutureBuilder(
            future: _favorites,
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.none &&
                  projectSnap.hasData == null) {
                //print('project snapshot data is: ${projectSnap.data}');
                return CircularProgressIndicator();
              }
              print("toto");
              print(projectSnap);
              print(projectSnap.hasData);
              return ListView.builder(
                itemCount: projectSnap.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify widgets.
                    key: UniqueKey(),
                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.all(18),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      _removeFromFavorites(index);

                      // Show a snackbar. This snackbar could also contain "Undo" actions.
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("${index} dismissed")));
                    },
                    child: Container(
                      padding: EdgeInsets.all(18),
                      width: MediaQuery.of(context).size.width,
                      color: (index % 2 == 0)
                          ? Theme.of(context).cardColor
                          : Theme.of(context).accentColor,
                      child: Text(
                        '${projectSnap.data[index]}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
