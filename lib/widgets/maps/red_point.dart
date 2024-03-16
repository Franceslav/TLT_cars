import 'package:yandex_mapkit/yandex_mapkit.dart';

MapObjectId mapObjectId = const MapObjectId('normal_icon_placemark');
getRedPoint({required double lat, required double long}) {
  return PlacemarkMapObject(
    mapId: mapObjectId,
    point: Point(latitude: lat, longitude: long),
    opacity: 0.7,
    //direction: 90,
    isDraggable: true,
    icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('asstes/point.png'),
        scale: 3,
        rotationType: RotationType.rotate)),
  );
}
