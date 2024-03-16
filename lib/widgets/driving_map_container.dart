import 'dart:async';
import 'dart:math';

import 'package:cars/bloc/live_search/live_search_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/maps/driving_page.dart';
import 'package:cars/widgets/maps/red_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'maps/models/app_lat_long.dart';
import 'maps/models/location_service.dart';

class DrivingMapContainer extends StatefulWidget {
  DrivingMapContainer({super.key});

  @override
  State<DrivingMapContainer> createState() => _DrivingMapContainerState();
}

class _DrivingMapContainerState extends State<DrivingMapContainer> {
  @override
  void initState() {
    super.initState();
  }

  final List<MapObject> mapObjects = [];

  bool initFlag = true;
  @override
  Widget build(BuildContext context) {
    final PlacemarkMapObject startPlacemark = PlacemarkMapObject(
      mapId: const MapObjectId('start_placemark'),
      point: Point(
          latitude: context.read<RouteFromToCubit>().get().from!.lat,
          longitude: context.read<RouteFromToCubit>().get().from!.long),
      // icon: PlacemarkIcon.single(
      //   PlacemarkIconStyle(
      //       image: BitmapDescriptor.fromAssetImage('asstes/point.png'),
      //       scale: 0.2),
      // ),
    );

    final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
      mapId: const MapObjectId('end_placemark'),
      point: Point(
          latitude: context.read<RouteFromToCubit>().get().to!.lat,
          longitude: context.read<RouteFromToCubit>().get().to!.long),
      // icon: PlacemarkIcon.single(PlacemarkIconStyle(
      //     image: BitmapDescriptor.fromAssetImage('lib/assets/route_end.png'),
      //     scale: 0.3)),
    );

    var resultWithSession = YandexDriving.requestRoutes(
        points: [
          RequestPoint(
              point: startPlacemark.point,
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: endPlacemark.point,
              requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(
            initialAzimuth: 0, routesCount: 5, avoidTolls: true));

    if (initFlag) {
      initFlag = false;
      () async {
        var location = await LocationService().getCurrentLocation();
        var mapObject = getRedPoint(lat: location.lat, long: location.long);
        setState(() {
          mapObjects.add(mapObject);
        });
      }();
    }
    return _SessionPage(
      startPlacemark,
      endPlacemark,
      resultWithSession.session,
      resultWithSession.result,
    );
  }
}

class _SessionPage extends StatefulWidget {
  final Future<DrivingSessionResult> result;
  final DrivingSession session;
  final PlacemarkMapObject startPlacemark;
  final PlacemarkMapObject endPlacemark;

  const _SessionPage(
      this.startPlacemark, this.endPlacemark, this.session, this.result);

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<_SessionPage> {
  late final List<MapObject> mapObjects = [
    widget.startPlacemark,
    widget.endPlacemark
  ];

  final List<DrivingSessionResult> results = [];
  bool _progress = true;

  @override
  void initState() {
    super.initState();
    () async {
      await _fetchCurrentLocation();
      await _init();
    }();
  }

  @override
  void dispose() {
    super.dispose();

    _close();
  }

  final mapControllerCompleter = Completer<YandexMapController>();

  /// Получение текущей геопозиции пользователя
  Future<void> _fetchCurrentLocation() async {
    AppLatLong location = AppLatLong(
      lat: context.read<RouteFromToCubit>().get().from!.lat,
      long: context.read<RouteFromToCubit>().get().from!.long,
    );
    // const defLocation = MoscowLocation();
    // try {
    //   location = await LocationService().getCurrentLocation();
    // } catch (_) {
    //   location = defLocation;
    // }

    await _moveToCurrentLocation(location);
    // await _init();
    setState(() {});
  }

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation:
          const MapAnimation(type: MapAnimationType.linear, duration: 0.5),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                YandexMap(
                  mapObjects: mapObjects,
                  onMapCreated: (controller) {
                    mapControllerCompleter.complete(controller);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
            SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    !_progress
                        ? Container()
                        : TextButton.icon(
                            icon: const CircularProgressIndicator(),
                            label: const Text('Cancel'),
                            onPressed: _cancel)
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _getList(),
                      )),
                ),
              ],
            ),
          ])))
        ],
      ),
    );
  }

  List<Widget> _getList() {
    final list = <Widget>[];

    if (results.isEmpty) {
      list.add((const Text('Nothing found')));
    }

    for (var r in results) {
      list.add(Container(height: 20));

      r.routes!.asMap().forEach((i, route) {
        list.add(
            Text('Route $i: ${route.metadata.weight.timeWithTraffic.text}'));
      });

      list.add(Container(height: 20));
    }

    return list;
  }

  Future<void> _cancel() async {
    await widget.session.cancel();

    setState(() {
      _progress = false;
    });
  }

  Future<void> _close() async {
    await widget.session.close();
  }

  Future<void> _init() async {
    await _handleResult(await widget.result);
  }

  Future<void> _handleResult(DrivingSessionResult result) async {
    setState(() {
      _progress = false;
    });

    if (result.error != null) {
      print('Error: ${result.error}');
      return;
    }

    setState(() {
      results.add(result);
    });

    setState(() {
      result.routes!.asMap().forEach((i, route) {
        if (i == 0)
          mapObjects.add(PolylineMapObject(
            mapId: MapObjectId('route_${i}_polyline'),
            polyline: Polyline(points: route.geometry),
            strokeColor: blue,
            strokeWidth: 3,
          ));
      });
    });
  }
}
