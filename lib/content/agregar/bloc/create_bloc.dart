import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foto_share/login/bloc/auth_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  File? _selectedPicture;

  CreateBloc() : super(CreateInitial()) {
    on<OnCreateTakePictureEvent>(_takePicture);
    on<OnCreateSaveDataEvent>(_saveData);
  }

  FutureOr<void> _saveData(event, emit) async {
    emit(CreateLoadingState());
    bool saved = await _saveFshare(event.dataToSave);
    emit(saved ? CreateSuccessState() : CreateFshareErrorState());
  }

  Future<bool> _saveFshare(Map<String, dynamic> dataToSave) async {
    try {
      // subir imagen al bucket de firebase storage
      String _imageUrl = await _uploadPictureToStorage();
      if (_imageUrl != "") {
        // en caso de haber subido la imagen, acutalizar el mapa
        dataToSave["picture"] = _imageUrl;
        dataToSave["publishedAt"] = Timestamp.fromDate(DateTime.now());
        dataToSave["stars"] = 0;
        dataToSave["username"] = FirebaseAuth.instance.currentUser!.displayName;
      } else {
        return false;
      }

      //Guardar Fshare en cloud Firestore
      var docRef =
          await FirebaseFirestore.instance.collection("fshare").add(dataToSave);
      _bandera();
      return await _updateUserDocumentReference(docRef.id);
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  FutureOr<void> _takePicture(event, emit) async {
    emit(CreateLoadingState());
    await _getImage();

    _selectedPicture != null
        ? emit(CreatePictureChangedState(picture: _selectedPicture!))
        : emit(CreatePictureErrorState());
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      _selectedPicture = File(pickedFile.path);
    } else {
      print('No image selected.');
      _selectedPicture = null;
    }
  }

  Future<String> _uploadPictureToStorage() async {
    try {
      var stamp = DateTime.now();
      if (_selectedPicture == null) return "";

//definir upload task
      UploadTask task = FirebaseStorage.instance
          .ref("fshares/imagen_${stamp}.png")
          .putFile(_selectedPicture!);
      // ejecutar la task
      await task;
      return await task.storage
          .ref("fshares/imagen_${stamp}.png")
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<bool> _updateUserDocumentReference(String fshareId) async {
    try {
      //query traer doc con id de user
      //query para traer el documento con el id d el usuario autenticado
      var queryUser = await FirebaseFirestore.instance
          .collection("user")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");

      //query para sacar la data del documento
      var docsRef = await queryUser.get();
      List<dynamic> listIds = docsRef.data()?["fotosListId"];

      //agregamos nuevo id
      listIds.add(fshareId);

      //guardar
      await queryUser.update({"fotosListId": listIds});
      return true;
    } catch (e) {
      print("Error al actualizar users collection: $e");
      return false;
    }
  }

  _bandera() {
    print("=====================================");
    print("||          to va bien             ||");
    print("||              __                 ||");
    print("||           __/o \\_               ||");
    print("||           \\____  \\              ||");
    print("||               /   \\             ||");
    print("||         __   //\\   \\            ||");
    print("||      __/o \\-//--\\   \\_/         ||");
    print("||      \\____  ___  \\  |           ||");
    print("||           ||   \\ |\\ |           ||");
    print("||          _||   _||_||           ||");
    print("||                                 ||");
    print("=====================================");
  }
}
