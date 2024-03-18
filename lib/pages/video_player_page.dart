import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/route_from_to.dart';
import 'package:cars/widgets/bottom_sheet/bottom_shet_header.dart';
import 'package:cars/widgets/bottom_sheet/pass_bottom_shet_body.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ext_video_player/ext_video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final RouteFromTo state;

  const VideoPlayerPage({Key? key, required this.state}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late VideoPlayerController _firstController;
  late VideoPlayerController _secondController;

  @override
  void initState() {
    super.initState();

    _firstController = VideoPlayerController.network(
        'rtmp://rtmp.streamaxia.com/streamaxia/1011875585')
      ..initialize().then((_) {
        setState(() {});
        _firstController.play();
      });

    _secondController = VideoPlayerController.network(
        'rtmp://rtmp.streamaxia.com/streamaxia/1011875585')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () => key.currentState!.expand());
    return Scaffold(
      key: _scaffoldKey,
      body: ExpandableBottomSheet(
        key: key,
        persistentHeader: BottomSheetHeader(),
        expandableContent: PassBottomSheetBody(),
        onIsExtendedCallback: () {
          print('exon');
        },
        onIsContractedCallback: () {},
        background: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 1000),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 50),
                      Expanded(
                        child: _firstController.value.initialized
                            ? VideoPlayer(_firstController)
                            : CircularProgressIndicator(),
                      ),
                      Expanded(
                        child: _secondController.value.initialized
                            ? VideoPlayer(_secondController)
                            : CircularProgressIndicator(),
                      ),
                    ],
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
