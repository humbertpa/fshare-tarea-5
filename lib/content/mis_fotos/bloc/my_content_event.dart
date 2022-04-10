part of 'my_content_bloc.dart';

abstract class MyContentEvent extends Equatable {
  const MyContentEvent();

  @override
  List<Object> get props => [];
}

class GetAllMyFotosEvent extends MyContentEvent {}

class EditFotoEvent extends MyContentEvent {
  final Map<String, dynamic> dataToUpdate;

  EditFotoEvent({required this.dataToUpdate});
  @override
  List<Object> get props => [dataToUpdate];
}
