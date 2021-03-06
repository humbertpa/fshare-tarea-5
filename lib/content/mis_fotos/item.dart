import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foto_share/content/espera/bloc/pending_bloc.dart';

import 'bloc/my_content_bloc.dart';

class ItemCargado extends StatefulWidget {
  final Map<String, dynamic> Data;
  ItemCargado({Key? key, required this.Data}) : super(key: key);

  @override
  State<ItemCargado> createState() => _ItemCargadoState();
}

class _ItemCargadoState extends State<ItemCargado> {
  bool _switchValue = false;
  var _cTitle = TextEditingController();
  var _cPicture = TextEditingController();
  var _cStars = TextEditingController();

  @override
  void initState() {
    _switchValue = widget.Data["public"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "${widget.Data["picture"]}",
                fit: BoxFit.cover,
              ),
            ),
            SwitchListTile(
              title: Text("${widget.Data["title"]}"),
              subtitle: Text("${widget.Data["publishedAt"].toDate()}"),
              value: _switchValue,
              onChanged: (newVal) {
                setState(() {
                  _switchValue = newVal;
                });
              },
            ),
            ElevatedButton(
              child: Text("        Editar        "),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("${widget.Data["title"]}"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _cTitle..text = widget.Data["title"],
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Titulo',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _cPicture..text = widget.Data["picture"],
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'imageUrl',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _cStars
                            ..text = widget.Data["stars"].toString(),
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Estrellas',
                          ),
                        ),
                      ],
                    ), //const Text('AlertDialog description'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          print("Aqui vamos");
                          Map<String, dynamic> fshareUpdate = widget.Data;
                          fshareUpdate["publishedAt"] =
                              Timestamp.fromDate(DateTime.now());
                          fshareUpdate["public"] = _switchValue;
                          fshareUpdate["picture"] = _cPicture.text;
                          fshareUpdate["stars"] = _cStars.text;
                          fshareUpdate["title"] = _cTitle.text;

                          BlocProvider.of<MyContentBloc>(context)
                              .add(EditFotoEvent(dataToUpdate: fshareUpdate));

                          Navigator.pop(context, 'OK');

                          BlocProvider.of<PendingBloc>(context)
                              .add(GetAllMyDisabledFotosEvent());
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
