import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/widgets/driving_map_container.dart';
import 'package:cars/widgets/menu/driver_menu.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/bottom_sheet/bottom_shet_header.dart';
import '../widgets/bottom_sheet/driver_app_bottom_sheet.dart';
import '../widgets/bottom_sheet/forms/driver_order_form.dart';
import '../widgets/car_status.dart';
import '../widgets/driver_car_status.dart';
import '../widgets/map_container.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var state = context.watch<RouteFromToCubit>().get();
    Future.delayed(Duration(seconds: 1), () => key.currentState!.expand());

    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawer: DriverMenu(),
      body: ExpandableBottomSheet(
        key: key,
        persistentHeader: BottomSheetHeader(),
        expandableContent: DriverOrderForm(),
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
                            ? Expanded(child: MapContainer())
                            : Expanded(child: DrivingMapContainer()),
                        Positioned(
                          child: IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              icon: const Icon(
                                Icons.menu,
                                size: 30,
                              )),
                        ),
                        Positioned(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            width: double.infinity,
                            child: Center(child: const DriverCarStatus()),
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
