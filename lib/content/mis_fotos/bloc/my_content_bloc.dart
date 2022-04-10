import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'my_content_event.dart';
part 'my_content_state.dart';

class MyContentBloc extends Bloc<MyContentEvent, MyContentState> {
  MyContentBloc() : super(MyContentInitial()) {
    on<MyContentEvent>(_getMyDisabledContent);
    on<EditFotoEvent>(_editarFoto);
  }

  FutureOr<void> _getMyDisabledContent(event, emit) async {
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

      // query de Dart filtrando la info utilizando como referencia la lista de ids de docs del usuario actual
/*       var myContentList = queryFotos.docs
          .where((doc) => listIds.contains(doc.id))
          .map((doc) => doc.data().cast<String, dynamic>())
          .toList(); */

      var myContentList =
          queryFotos.docs.where((doc) => listIds.contains(doc.id)).map((doc) {
        var mp = doc.data().cast<String, dynamic>();
        mp["id"] = doc.id;
        return mp;
      }).toList();

      myContentList.forEach((mapa) => print("${mapa["id"]}\n"));

      // lista de documentos filtrados del usuario con sus datos de fotos en espera
      emit(MyContentSuccessState(myData: myContentList));
    } catch (e) {
      print("Error al obtener items en espera: $e");
      emit(MyContentErrorState());
      emit(MyContentEmptyState());
    }
  }

  FutureOr<void> _editarFoto(event, emit) async {
    emit(UpdateLoadingState());
    bool updated = await _updateFshare(event.dataToUpdate);
    emit(updated ? UpdateSuccessState() : UpdateErrorState());
  }

  Future<bool> _updateFshare(Map<String, dynamic> dataToUpdate) async {
    var docRef = await FirebaseFirestore.instance.collection("fshare");
    print("Mapa antiguo\n${dataToUpdate}");
    docRef.doc(dataToUpdate['id']).update(dataToUpdate).then((value) {
      print("Informacion actualizada");
      return true;
    }).catchError((error) {
      print("No se pudo actualizar la informacion: $error");
      return false;
    });
    return false;
  }
}
