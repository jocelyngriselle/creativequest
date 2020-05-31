import 'package:flutter/material.dart';
import 'favorite.dart';
import 'routes.dart';

class FavoritesPage extends StatefulWidget {
  final List<Action> ideaTypes;

  FavoritesPage({Key key, this.ideaTypes}) : super(key: key);

  @override
  _FavoritesPageState createState() {
    return _FavoritesPageState();
  }
}

class _FavoritesPageState extends State<FavoritesPage> {
  FavoriteRepository _repository = FavoriteRepository();
  List<Favorite> favorites;

  void deleteFavorite(index, context) async {
    await _repository.removeFavorite(favorites[index]);
  }

  void deleteFavorites(context) async {
    await _repository.removeFavorites();
    setState(() {});
  }

  Future<void> deleteAllPopUp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text('Delete All'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete all yours favorites ideas ?',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Nevermind',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'Yes, delete',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.red),
              ),
              onPressed: () {
                deleteFavorites(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).accentColor,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Flexible(
                  flex: 4,
                  child: Center(
                    child: Text('FAVORITES',
                        style: Theme.of(context).textTheme.headline5),
                  )),
              Flexible(
                child: Container(),
                flex: 1,
              )
            ],
          ),
          elevation: 0.0,

//          actions: <Widget>[
//            IconButton(
//              icon: Icon(
//                Icons.delete_forever,
//                color: Theme.of(context).accentColor,
//              ),
//              onPressed: () {
//                deleteAllPopUp();
//              },
//            ),
//          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: FutureBuilder(
            future: _repository.getFavorites(),
            builder: (context, snapshot) {
              final maxWidth = MediaQuery.of(context).size.width;
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              favorites = new List<Favorite>.from(snapshot.data.documents
                  .map((document) => Favorite.fromSnapshot(document))).toList();
              return ListView.builder(
                itemCount: favorites.length,
//                separatorBuilder: (BuildContext context, int index) =>
//                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    //width: maxWidth * 0.8,
//                    padding: EdgeInsets.all(18),
                    margin:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      //color: Colors.white,
//                          boxShadow: [
//                            BoxShadow(
//                              color: Colors.black.withOpacity(0.1),
//                              spreadRadius: 1.0, //extend the shadow
//                            )
//                          ],
                      borderRadius: new BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),

                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: UniqueKey(),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        deleteFavorite(index, context);
                      },
                      background: Container(
//                        margin: EdgeInsets.symmetric(
//                            vertical: 16.0, horizontal: 0.0),
//                        width: maxWidth * 0.9,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          //color: Colors.red,
//                          boxShadow: [
//                            BoxShadow(
//                              color: Colors.black.withOpacity(0.1),
//                              spreadRadius: 1.0, //extend the shadow
//                            )
//                          ],
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),

                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Remove',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),

                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0.0),
                            child: Center(
                              child: Container(
//                              margin: EdgeInsets.symmetric(
//                                  vertical: 16.0, horizontal: 16.0),
                                width: maxWidth * 0.9,
                                constraints: BoxConstraints(minHeight: 200.0),
                                decoration: BoxDecoration(
//                                  color: (index % 2 != 0)
//                                      ? Theme.of(context).primaryColor
//                                      : Theme.of(context).accentColor,
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1.0, //extend the shadow
                                    )
                                  ],
                                  borderRadius: new BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      child: Opacity(
                                          opacity: 0.1,
                                          child: FutureBuilder(
                                            future: favorites[index].getImage(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              return snapshot.data;
                                            },
                                          )),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        '${favorites[index].description}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            top: 0.0,
                            child: FloatingActionButton(
                              heroTag: 'deleteFavorite$index',
                              onPressed: () {},
                              child: Icon(
                                Icons.favorite,
                                color: Theme.of(context).cardColor,
                              ),
                              backgroundColor: Theme.of(context).accentColor,
//                              backgroundColor: (index % 2 != 0)
//                                  ? Theme.of(context).accentColor
//                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
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
