import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
//   (1) to identify the distance and travel time between two locations .
  getTravelTimeAndDestination() async {
    Dio dio = new Dio();
    Response response = await
//  ( get request includes origins + destinations + your API_KEY )
    dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=26.55968874472137, 31.696824371859652&destinations=30.045297464404054, 31.23529013970594&key=AIzaSyCdKmIi2H5bygsSHAaUMI5028J7h90PtsQ");
    print(response.data);
  }
// (2) to draw a polyLine

  List<Polyline> myPolyline = [];
  createPolyLine() {
    myPolyline.add(Polyline(
        polylineId: PolylineId("1"),
        color: Colors.red,
        width: 5,
        jointType: JointType.bevel,
        points: [
          LatLng(26.55924490593214, 31.692555036767065),
          LatLng(26.55924490593214, 31.692555036767065),
          LatLng(26.557978141304638, 31.693220224571164),
          LatLng(26.556893702852058, 31.69428237934769),
          LatLng(26.556836121748283, 31.694743719308697),
          LatLng(26.556082766528135, 31.695167508356242),
          LatLng(26.555535741139447, 31.695231881357813),
          LatLng(26.555190250086724, 31.693960514345154),

        ]));
  }

//  (3) drawing a polygon
//  note : the first and lat point must be the same to draw the  shape you want
  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = new List();
    polygonCoords.add(LatLng(26.359746871799988, 31.886469287147367));
    polygonCoords.add(LatLng(26.354055661981207, 31.877714557338678));
    polygonCoords.add(LatLng(26.324595330700127, 31.89050332931416));
    polygonCoords.add(LatLng(26.321518101248724, 31.899172228438474));

    polygonCoords.add(LatLng(26.321671964663185, 31.89908639775408));
    polygonCoords.add(LatLng(26.326287772045138, 31.898485582963286));
    polygonCoords.add(LatLng(26.32882638768224, 31.904150408133635));


    polygonCoords.add(LatLng(26.33913413380464, 31.898399752278884));
    polygonCoords.add(LatLng(26.34874874104059, 31.892992419161732));
    polygonCoords.add(LatLng(26.359746871799988, 31.886469287147367));

    Set<Polygon> polygonSet = new Set();
    polygonSet.add(Polygon(
        polygonId: PolygonId('1'),
        points: polygonCoords,fillColor: Colors.blue.withOpacity(.2), strokeWidth: 1,
        strokeColor: Colors.red),);
    return polygonSet;
  }
//  (4) to draw a circle

  Set<Circle> circles = Set.from([
    Circle(
        circleId: CircleId("1"),
        center: LatLng(26.658863607430504, 31.67266187317845),
        radius: 3000,
        fillColor: Colors.red.withOpacity(.2),
        strokeWidth: 2,
        visible: true),

    Circle(
        circleId: CircleId("2"),
        center: LatLng(26.708492297731933, 31.60436310412679),
        radius: 3000,
        fillColor: Colors.red.withOpacity(.2),
        strokeWidth: 2,
        visible: true),

    Circle(
        circleId: CircleId("3"),
        center: LatLng(26.679452945745357, 31.489983226121176),
        radius: 3000,
        fillColor: Colors.red.withOpacity(.2),
        strokeWidth: 2,
        visible: true),
  ]);

//  (5) to add a marker
  var markers = HashSet<Marker>();
//  adding image to the marker
  BitmapDescriptor customMarkerImage;
  getCustomMarker() async {
    customMarkerImage = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/boy.jpg');
  }

  @override
  void initState() {
    createPolyLine();
    getCustomMarker();
    super.initState();
    getTravelTimeAndDestination();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polylines',
      home: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
//                buildingsEnabled: true,
//                myLocationButtonEnabled: true,
                polylines: myPolyline.toSet(),
                polygons: myPolygon(),
                mapType: MapType.normal,
//                mapToolbarEnabled: true,
//                indoorViewEnabled: true,
//                trafficEnabled: true,
                initialCameraPosition: CameraPosition(
                    zoom: 10,
                    target: LatLng(26.55922810644215, 31.696481049122053),
                    bearing: 20,
                    tilt: 20),
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    markers.add(Marker(
                        markerId: MarkerId("1"),
                        position:
                        LatLng(23.55937500616875, 36.69249388729676),

                        visible: true,
                        infoWindow: InfoWindow(title: "")));
                  });
                },
                markers: markers,
                circles: circles
            ),

//
//
          ],
        ),
      ),
    );
  }
}
