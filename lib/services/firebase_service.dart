import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase3/firebase.dart' as fb;

import '../models/message.dart';

@Injectable()
class FirebaseService {
  fb.Database _fbDatabase;
  fb.Auth _fbAuth;
  fb.DatabaseReference _fbRefMessages;
  String userName;
  fb.User user;
  bool isLogged;
  List<Message> messages = [];

  FirebaseService() {
    fb.initializeApp(
        apiKey: "AIzaSyBRB-ZHPyTLu_ZRNAhiqsrLTa6UEWVeGr0",
        authDomain: "dartchatapp-f4545.firebaseapp.com",
        databaseURL: "https://dartchatapp-f4545.firebaseio.com",
        storageBucket: "dartchatapp-f4545.appspot.com"
        );

    //LOG REF & INIT
    _fbDatabase = fb.database();
    _fbAuth = fb.auth();   

  }

  //LOG IN
  void userLogged(userName) {
    window.sessionStorage['userName'] = this.userName = userName;
    this.isLogged = true;
    _fbAuth.onAuthStateChanged.listen(_authChanged);
    print("${userName} listening auth...");
    _signIn();
  }

  Future _signIn() async {
    //Async functions always return a Future, epic dart's async/await
    try {
      await _fbAuth.signInAnonymously();
      _listeningMessages();
    } catch (error) {
      print("$runtimeType::login() -- $error");
    }
  }
  void _listeningMessages() {
    messages.clear();
    _fbRefMessages = _fbDatabase.ref("messages");
    _fbRefMessages.onChildAdded.listen(_newMessage);
    print("listening new messages...");
  }

  void _authChanged(fb.AuthEvent event) {
    if (user != event.user) {
      user = event.user;
      print('auth changed: ${userName}');
    } else if(user == null) {
      print('auth: null');
    }
  }

  // NEW MESSAGE TO LIST
  void _newMessage(fb.QueryEvent event) {
    Message msg = new Message.fromMap(event.snapshot.val());
    messages.add(msg);
    //WHEN OTHERS SEND MESSAGE
    if (msg.name != userName) {
      _sound(DateTime.parse(msg.datetime));
    }
  }
  //GIVING A SOUND
  void _sound(DateTime msg) {
    DateTime now = new DateTime.now();
    if (now.year == msg.year && 
        now.month == msg.month &&
        now.day == msg.day &&
        now.hour == msg.hour &&
        now.minute == msg.minute &&
        (now.second == msg.second || now.second == msg.second+1)) {
      print('give a sound');
      var audio = new AudioElement("./assets/audio/beep.wav");
      audio.autoplay = true;
    }
  }

  //SEND MESSAGE
  Future sendMessage({String text, String imageURL}) async {
    try {
      var datetime = new DateTime.now().toString();
      Message msg = new Message(userName, datetime, text, imageURL);
      await _fbRefMessages.push(msg.toMap());
    } catch (error) {
      print("$runtimeType::sendMessage() -- $error");
    }
  }

  void signOut() {
    _fbAuth.signOut();
    isLogged = false;
    user = null;
    window.sessionStorage.clear();
  }
}
