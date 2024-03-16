import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/widgets/bottom_sheet/bottom_shet_header.dart';
import 'package:cars/widgets/bottom_sheet/pass_bottom_shet_body.dart';
import 'package:cars/widgets/buttons/video_button.dart';
import 'package:cars/widgets/car_status.dart';
import 'package:cars/widgets/driving_map_container.dart';
import 'package:cars/widgets/map_container.dart';
import 'package:cars/widgets/menu/pass_menu.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cars/pages/video_player_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PassHomePage extends StatefulWidget {
  const PassHomePage({Key? key}) : super(key: key);

  @override
  State<PassHomePage> createState() => _PassHomePageState();
}

class _PassHomePageState extends State<PassHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var state = context.watch<RouteFromToCubit>().get();

    Future.delayed(Duration(seconds: 1), () => key.currentState!.expand());
    return Scaffold(
      key: _scaffoldKey,
      drawer: PassMenu(),
      floatingActionButton: VideoButton(
        onPressed: () {
          Get.to(() => VideoPlayerPage(state: state));
        },
      ),
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
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        state.from == null || state.to == null
                            ? MapContainer()
                            : DrivingMapContainer(),
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
                        Positioned(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: const Center(child: CarStatus()),
                          ),
                        ),
                      ],
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
