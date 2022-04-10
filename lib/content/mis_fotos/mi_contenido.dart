import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

import 'item.dart';
import 'bloc/my_content_bloc.dart';

class MiContenido extends StatelessWidget {
  const MiContenido({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyContentBloc, MyContentState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MyContentLoadingState) {
          return ListView.builder(
            itemCount: 25,
            itemBuilder: (BuildContext context, int index) {
              return YoutubeShimmer();
            },
          );
        } else if (state is MyContentEmptyState) {
          return Center(
            child: Text("No hay datos por mostrar"),
          );
        } else if (state is MyContentSuccessState) {
          return Container(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: state.myData.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemCargado(
                  Data: state.myData[index],
                );
              },
            ),
          );
        } else {
          print(state);
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
