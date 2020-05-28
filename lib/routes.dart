import 'package:flutter/material.dart';
import 'login_page.dart';
import 'idea_submit.dart';
import 'action_page.dart';
import 'favorites_page.dart';
import 'idea_page.dart';
import 'account_page.dart';

const String loginRoute = '/login';
const String accountRoute = '/account';
const String actionRoute = '/actions';
const String ideaRoute = '/ideas';
const String submitRoute = '/submit';
const String favoriteRoute = '/favorites';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case actionRoute:
        return MaterialPageRoute(builder: (_) => ActionsPage());
      case accountRoute:
        return MaterialPageRoute(builder: (_) => AccountPage());
      case ideaRoute:
        var action = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => IdeaPage(
            action: action,
          ),
        );
      case favoriteRoute:
        return MaterialPageRoute(builder: (_) => FavoritesPage());
      case submitRoute:
        var action = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => SubmitIdeaPage(
            action: action,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
