import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ItemPublic extends StatefulWidget {
  final Map<String, dynamic> publicFData;
  ItemPublic({Key? key, required this.publicFData}) : super(key: key);
  @override
  State<ItemPublic> createState() => _ItemPublicState();
}

class _ItemPublicState extends State<ItemPublic> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "${widget.publicFData["picture"]}",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text("${widget.publicFData["username"].toString()[0]}"),
              ),
              title: Text("${widget.publicFData["title"]}"),
              subtitle: Text("${widget.publicFData["publishedAt"]}"),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: Icon(Icons.star_outlined, color: Colors.green),
                    tooltip: "Likes: ${widget.publicFData["stars"]}",
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: "Compartir",
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      final image = "${widget.publicFData["picture"]}";
                      final url = Uri.parse(image);
                      final response = await http.get(url);
                      final bytes = response.bodyBytes;

                      final temp = await getTemporaryDirectory();
                      final path = '${temp.path}/image.jpg';
                      File(path).writeAsBytesSync(bytes);

                      await Share.shareFiles([path],
                          text: "${widget.publicFData["title"]}" +
                              " " +
                              "${widget.publicFData["publishedAt"].toDate().toString().split(" ")[0]}");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
