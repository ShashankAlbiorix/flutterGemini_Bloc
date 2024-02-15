part of 'home_bloc.dart';


class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class MessageSentEvent extends HomeEvent {
  String msg;
  MessageSentEvent(this.msg);

  @override
  List<Object> get props => [msg];
}

