import 'package:flutter/material.dart';

class ItemCargado extends StatefulWidget {
  final Map<String, dynamic> nonPublicFData;
  ItemCargado({Key? key, required this.nonPublicFData}) : super(key: key);

  @override
  State<ItemCargado> createState() => _ItemCargadoState();
}

class _ItemCargadoState extends State<ItemCargado> {
  bool _switchValue = false;

  @override
  void initState() {
    _switchValue = widget.nonPublicFData["public"];
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
                "${widget.nonPublicFData["picture"]}",
                fit: BoxFit.cover,
              ),
            ),
            SwitchListTile(
              title: Text("${widget.nonPublicFData["title"]}"),
              subtitle:
                  Text("${widget.nonPublicFData["publishedAt"].toDate()}"),
              value: _switchValue,
              onChanged: (newVal) {
                setState(() {
                  _switchValue = newVal;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
