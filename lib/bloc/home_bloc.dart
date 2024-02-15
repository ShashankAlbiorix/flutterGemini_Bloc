


import 'package:bloc/bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:equatable/equatable.dart';

import '../models/chatMessageModel.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<ChatMessageModel> listMessage = [];
  final gemini = Gemini.instance;


  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});

    on<MessageSentEvent>((event, emit) async {
      emit(HomeLoading());
      await gemini.text(event.msg)
          .then((value){
        listMessage.add(ChatMessageModel(timestamp: DateTime.now().millisecondsSinceEpoch,isUser: false,msgContent: value?.output ?? "Something went wrong")) ;
      }).catchError((e) => print(e));

      emit(HomeLoaded(listMessage));

    });
  }
}
