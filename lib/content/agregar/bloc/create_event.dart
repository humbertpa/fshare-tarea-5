part of 'create_bloc.dart';

abstract class CreateEvent extends Equatable {
  const CreateEvent();

  @override
  List<Object> get props => [];
}

//click al boton de foto
class OnCreateTakePictureEvent extends CreateEvent {}

//click al boton de guardar
class OnCreateSaveDataEvent extends CreateEvent {
  final Map<String, dynamic> dataToSave;

  OnCreateSaveDataEvent({required this.dataToSave});
  @override
  List<Object> get props => [dataToSave];
}
