part of 'my_content_bloc.dart';

abstract class MyContentState extends Equatable {
  const MyContentState();

  @override
  List<Object> get props => [];
}

class MyContentInitial extends MyContentState {}

class MyContentSuccessState extends MyContentState {
  // lista de elementos de firebase "fshare collection"
  final List<Map<String, dynamic>> myData;

  MyContentSuccessState({required this.myData});

  @override
  List<Object> get props => [myData];
}

class MyContentErrorState extends MyContentState {}

class MyContentEmptyState extends MyContentState {}

class MyContentLoadingState extends MyContentState {}
