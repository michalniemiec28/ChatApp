import 'dart:html';

import 'package:angular2/core.dart';

import '../app_header/app_header.dart';
import '../app_login/app_login.dart';
import '../../services/firebase_service.dart';
import '../../pipes/string_to_date_pipe.dart';

import '../../directives/vu_scroll_down.dart';
import '../../directives/vu_hold_focus.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [AppHeader, AppLogin, VuScrollDown, VuHoldFocus],
    providers: const [FirebaseService],
    styleUrls: const ['app_component.css'],
    pipes: const [StringToDatePipe])
class AppComponent implements OnInit {
  final FirebaseService fbService;
  String inputText = "";
  String userName;

  AppComponent(FirebaseService this.fbService);

  //SESSION STORAGE
  ngOnInit() {
    if (window.sessionStorage['userName'].toString() != "null") {
      this.userName = window.sessionStorage['userName'].toString();
      print("user name from session storage: " + this.userName);
      fbService.userLogged(userName);
    } else {
      print("new session");
    }
  } 

  //MESSAGE INPUT
  void sendTextMessage() {
    String messageText = inputText.trim();
    if (messageText.isNotEmpty) {
      fbService.sendMessage(text: messageText);
      inputText = "";
    }
  }
}
