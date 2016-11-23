import 'dart:html';

import 'package:angular2/core.dart';

import '../../services/firebase_service.dart';

@Component(
    selector: 'app-login',
    templateUrl: 'app_login.html',
    styleUrls: const ['app_login.css'])
class AppLogin {
  final FirebaseService fbService;
  String inputText = "";
  
  AppLogin(FirebaseService this.fbService);

  //NAME INPUT
  void userLoggedEvent() {
    String userName = inputText.trim();
    if (userName.isNotEmpty) {
      print('login event');
      fbService.userLogged(userName);
    }
  }
}
