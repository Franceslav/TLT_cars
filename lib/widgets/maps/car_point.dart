import 'package:cars/models/car.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

MapObjectId mapObjectId = const MapObjectId('normal_icon_placemark');
getCarPoint() {
  return PlacemarkMapObject(
    mapId: mapObjectId,
    point: Point(latitude: car.lat, longitude: car.long),
    opacity: 1,
    //direction: 90,
    isDraggable: true,
    icon: PlacemarkIcon.single(PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage('asstes/car.png'),
        scale: 4,
        rotationType: RotationType.rotate)),
  );
}
