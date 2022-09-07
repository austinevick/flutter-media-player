import 'package:flutter/material.dart';
import 'package:flutter_media_player/view/home_view/home_view_model.dart';
import 'package:flutter_media_player/view/video_view/video_view.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.nonReactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(model.title),
              ),
              body: Center(
                child: ListView.builder(
                    itemCount: model.videos.length,
                    itemBuilder: (ctx, i) => ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      VideoView(url: model.videos[i]))),
                          leading: CircleAvatar(child: Text("${i + 1}")),
                          title: Text(model.videos[i]),
                        )),
              ),
            ));
  }
}
