import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'my_content_event.dart';
part 'my_content_state.dart';

class MyContentBloc extends Bloc<MyContentEvent, MyContentState> {
  MyContentBloc() : super(MyContentInitial()) {
    on<MyContentEvent>(_getMyContent);
    on<EditFotoEvent>(_editarFoto);
  }

  FutureOr<void> _getMyContent(event, emit) async {
    print("================================================");
    print(" Se ha ejecutado el metodo _getMyContent");
    print("================================================");

    emit(MyContentLoadingState());
    try {
      // query para traer el documento con el id del usuario autenticado
      var queryUser = await FirebaseFirestore.instance
          .collection("user")
          .doc("${FirebaseAuth.instance.currentUser!.uid}");

      // query para sacar la data del documento
      var docsRef = await queryUser.get();

      var listIds = docsRef.data()?["fotosListId"];

      // query para sacar documentos de fshare
      var queryFotos =
          await FirebaseFirestore.instance.collection("fshare").get();
      var myContentList =
          queryFotos.docs.where((doc) => listIds.contains(doc.id)).map((doc) {
        var mp = doc.data().cast<String, dynamic>();
        mp["id"] = doc.id;
        return mp;
      }).toList();

      //myContentList.forEach((mapa) => print("${mapa["id"]}\n"));

      // lista de documentos filtrados del usuario con sus datos de fotos en espera
      emit(MyContentSuccessState(myData: myContentList));
    } catch (e) {
      print("Error al obtener items en espera: $e");
      emit(MyContentErrorState());
      emit(MyContentEmptyState());
    }
  }

  FutureOr<void> _editarFoto(event, emit) async {
    print("================================================");
    print(" Se ha ejecutado el metodo _editarFoto");
    print("================================================");

    emit(UpdateLoadingState());
    bool updated = await _updateFshare(event.dataToUpdate);
    print("\n\n\nel estado de updated es ${updated}\n\n\n");
    emit(updated ? UpdateSuccessState() : UpdateErrorState());
  }

  Future<bool> _updateFshare(Map<String, dynamic> dataToUpdate) async {
    print("================================================");
    print(" Se ha ejecutado el metodo _updateFshare");
    print("================================================");
    var docRef = await FirebaseFirestore.instance.collection("fshare");
    print("Mapa antiguo\n${dataToUpdate}");

    try {
      docRef
          .doc(dataToUpdate['id'])
          .update(dataToUpdate)
          .then((value) => print("Informacion actualizada"))
          .catchError(
              (error) => print("No se pudo actualizar la informacion: $error"));
      return true;
    } catch (e) {
      return false;
    }
  }
}
