part of 'my_content_bloc.dart';

abstract class MyContentEvent extends Equatable {
  const MyContentEvent();

  @override
  List<Object> get props => [];
}

class GetAllMyFotosEvent extends MyContentEvent {}
