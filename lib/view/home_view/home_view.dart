import 'package:flutter/material.dart';
import 'package:flutter_media_player/view/home_view/home_view_model.dart';
import 'package:flutter_media_player/view/video_view/video_view.dart';
import 'package:flutter_media_player/widget/custom_button.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                title: Text(model.title),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        CustomButton(
                            selectedIndex: 0,
                            text: 'Remote',
                            onPressed: () => model.setIndexValue(0)),
                        CustomButton(
                            selectedIndex: 1,
                            text: 'Local',
                            onPressed: () => model.setIndexValue(1)),
                      ],
                    ),
                  ),
                  model.selectedIndex == 0
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: model.videos.length,
                              itemBuilder: (ctx, i) => ListTile(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => VideoView(
                                                url: model.videos[i]))),
                                    leading:
                                        CircleAvatar(child: Text("${i + 1}")),
                                    title: Text(model.videos[i]),
                                  )),
                        )
                      : model.isBusy
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: model.data!.length,
                                  itemBuilder: (ctx, i) => Card(
                                        child: ListTile(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (ctx) => VideoView(
                                                      url: model
                                                          .data![i].path))),
                                          leading: CircleAvatar(
                                              child: Text("${i + 1}")),
                                          title: Text(model.data![i].path
                                              .split('/')
                                              .last),
                                        ),
                                      )),
                            ),
                ],
              ),
            ));
  }
}
