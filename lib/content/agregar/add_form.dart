import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/create_bloc.dart';

class AddForm extends StatefulWidget {
  AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  var _titleC = TextEditingController();
  bool _defaultSwitchValue = false;
  File? image;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateBloc, CreateState>(
      listener: (context, state) {
        if (state is CreatePictureErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error al elegir imagen valida.."),
            ),
          );
        } else if (state is CreateFshareErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error al guardar la Fshare.."),
            ),
          );
        } else if (state is CreateSuccessState) {
          _titleC.clear();
          _defaultSwitchValue = false;
          image = null;
        } else if (state is CreatePictureChangedState) {
          image = state.picture;
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              SizedBox(height: 24),
              MaterialButton(
                child: Text("Foto"),
                onPressed: () {
                  //bloc tomar foto
                  BlocProvider.of<CreateBloc>(context)
                      .add(OnCreateTakePictureEvent());
                },
              ),
              image != null ? Image.file(image!, height: 120) : Container(),
              TextField(
                controller: _titleC,
                decoration: InputDecoration(
                  label: Text("Title"),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              SwitchListTile(
                title: Text("Publicar"),
                value: _defaultSwitchValue,
                onChanged: (newValue) {
                  _defaultSwitchValue = newValue;
                  setState(() {});
                },
              ),
              MaterialButton(
                child: Text("Guardar"),
                onPressed: () {
                  //crear Map a guardar
                  Map<String, dynamic> fshareData = {};
                  fshareData = {
                    "title": _titleC.value.text,
                    "public": _defaultSwitchValue,
                  };
                  BlocProvider.of<CreateBloc>(context)
                      .add(OnCreateSaveDataEvent(dataToSave: fshareData));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
