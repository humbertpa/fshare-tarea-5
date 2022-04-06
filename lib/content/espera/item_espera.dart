import 'package:flutter/material.dart';

class ItemEspera extends StatefulWidget {
  final Map<String, dynamic> nonPublicFData;
  ItemEspera({Key? key, required this.nonPublicFData}) : super(key: key);

  @override
  State<ItemEspera> createState() => _ItemEsperaState();
}

class _ItemEsperaState extends State<ItemEspera> {
  bool _switchValue = false;

  @override
  void initState() {
    _switchValue = widget.nonPublicFData["public"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
            subtitle: Text("${widget.nonPublicFData["publishedAt"].toDate()}"),
            value: _switchValue,
            onChanged: (newVal) {
              setState(() {
                _switchValue = newVal;
              });
            },
          )
        ],
      ),
    );
  }
}
