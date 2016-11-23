
class Message {
  final String name;
  final String datetime;
  final String text;
  String imageURL;

  Message(this.name, [this.datetime, this.text, this.imageURL]) {}

  Message.fromMap(Map map) :
        this(map['name'], map['datetime'], map['text'],  map['imageURL']);

  
  Map toMap() => {
    "name": name,
    "datetime" : datetime,
    "text": text,
    "imageURL": imageURL
  };
}