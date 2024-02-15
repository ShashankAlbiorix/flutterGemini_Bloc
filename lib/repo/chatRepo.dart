

import 'package:flutter_gemini/flutter_gemini.dart';

class ChatRepository {
  final gemini = Gemini.instance;

  Future<String?> sendMsg(String msg) async {
    gemini.text(msg)
        .then((value){
      return value?.output  ;
    })
        .catchError((e) => print(e));
    return "Something Went Wrong";
  }

}