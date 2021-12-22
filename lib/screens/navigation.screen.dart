import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:courier_app/providers/directions.dart';
import 'package:courier_app/providers/functionality.dart';
import 'package:courier_app/providers/packages.dart';
import 'package:courier_app/widgets/appDrawer.dart';
import 'package:courier_app/widgets/customBar.dart';
import 'package:courier_app/widgets/endButton.dart';
import 'package:courier_app/widgets/map.dart';
import 'package:courier_app/widgets/package.widget.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  Future<LocationData> getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    final packages = Provider.of<Packages>(context).packages;
    final courierId = Provider.of<Functionality>(context).courierId;

    Future<void> _startButtonOnPress() async {
      await Provider.of<Directions>(context, listen: false)
          .setPackagesForCourier(courierId)
          .then((res) async {
        await Provider.of<Packages>(context, listen: false)
            .getPackages(courierId);
      });
    }

    // ignore: avoid_init_to_null
    //dynamic previousLocation = null;

    // Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   LocationData locationData = await getLocation();
    //   if (previousLocation != locationData) {
    //     await Provider.of<Directions>(context, listen: false).updatePosition(
    //       Position(
    //         latitude: locationData.latitude!.toInt(),
    //         longitude: locationData.longitude!.toInt(),
    //       ),
    //       courierId,
    //     );
    //     previousLocation = locationData;
    //   }
    // });

    return packages.isEmpty
        ? Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        _startButtonOnPress();
                      },
                      child: const Text('Rozpocznij Pracę'),
                    )
                  ],
                ),
              ],
            ),
          )
        : Scaffold(
            drawer: const AppDrawer(),
            appBar: const CustomBar(),
            body: Column(
              children: [
                const MapWidget(),
                packages.isEmpty
                    ? const EndButton()
                    : PackageWidget(packages[0], true)
              ],
            ),
          );
  }
}
