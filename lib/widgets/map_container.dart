import 'dart:async';

import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/live_search/live_search_bloc.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/models/car.dart';

import 'package:cars/widgets/maps/car_point.dart';

import 'package:cars/widgets/maps/red_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'maps/models/app_lat_long.dart';
import 'maps/models/location_service.dart';

class MapContainer extends StatefulWidget {
  MapContainer({super.key});

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  final mapControllerCompleter = Completer<YandexMapController>();

  /// Проверка разрешений на доступ к геопозиции пользователя
  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  /// Получение текущей геопозиции пользователя
  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        context.read<AppBottomFormCubit>().get() == ShowBottomForm.orderNow
            ? CameraPosition(
                target: Point(
                  latitude: car.lat,
                  longitude: car.long,
                ),
                zoom: 15,
              )
            : context.read<RouteFromToCubit>().get().from != null
                ? CameraPosition(
                    target: Point(
                      latitude:
                          context.read<RouteFromToCubit>().get().from!.lat,
                      longitude:
                          context.read<RouteFromToCubit>().get().from!.long,
                    ),
                    zoom: 15,
                  )
                : CameraPosition(
                    target: Point(
                      latitude: appLatLong.lat,
                      longitude: appLatLong.long,
                    ),
                    zoom: 15,
                  ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initPermission();
  }

  final List<MapObject> mapObjects = [];
  bool initFlag = true;

  @override
  Widget build(BuildContext context) {
    if (initFlag) {
      initFlag = false;
      () async {
        AppLatLong location;
        if (context.read<RouteFromToCubit>().get().from != null) {
          location = AppLatLong(
            lat: context.read<RouteFromToCubit>().get().from!.lat,
            long: context.read<RouteFromToCubit>().get().from!.long,
          );
        } else {
          location = await LocationService().getCurrentLocation();
        }

        var mapObject =
            context.read<AppBottomFormCubit>().get() == ShowBottomForm.orderNow
                ? getCarPoint()
                : getRedPoint(
                    lat: location.lat,
                    long: location.long,
                  );
        setState(() {
          mapObjects.add(mapObject);
        });
      }();
    }
    return Container(
      width: double.infinity,
      child: YandexMap(
        onMapTap: (p) {
          setState(() {
            mapObjects.clear();
            context.read<LiveSearchBloc>().add(
                LiveSearchEvent.fetch(text: '${p.latitude} ${p.longitude}'));
            mapObjects.add(getRedPoint(lat: p.latitude, long: p.longitude));
          });
        },
        mapObjects: mapObjects,
        onMapCreated: (controller) {
          mapControllerCompleter.complete(controller);
        },
      ),
    );
  }
}
