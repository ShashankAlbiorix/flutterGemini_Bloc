part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}


final class HomeLoaded extends HomeState {
  List<ChatMessageModel> messags;
  HomeLoaded(this.messags);
  @override
  List<Object> get props => [messags];
}
