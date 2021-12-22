// ignore_for_file: use_key_in_widget_constructors

import 'package:courier_app/models/package.dart';
import 'package:courier_app/providers/directions.dart';
import 'package:courier_app/providers/functionality.dart';
import 'package:courier_app/providers/packages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageWidget extends StatefulWidget {
  final Package package;
  final bool isOnly;

  const PackageWidget(this.package, this.isOnly);

  @override
  PackageWidgetState createState() => PackageWidgetState();
}

class PackageWidgetState extends State<PackageWidget> {
  bool _expanded = false;

  void updatePackage(String courierId, bool isDelivered) {
    Provider.of<Packages>(context, listen: false)
        .updatePackage(courierId, widget.package.id, isDelivered);
  }

  void onCallClick() {
    launch("tel://${widget.package.receiver.phoneNumber}");
  }

  void onMessageClick() {
    launch(
        'sms:${widget.package.receiver.phoneNumber}?body=Proszę%20o%20kontakt.%20Kurier');
  }

  String getTime() {
    final packageDistance =
        Provider.of<Directions>(context, listen: false).packageDistance;
    num seconds = packageDistance
        .firstWhere((pd) => pd.packageId == widget.package.id)
        .time;
    int formattedSeconds = int.parse(seconds.toStringAsFixed(0));
    int minutes = Duration(seconds: formattedSeconds).inMinutes;
    return minutes.toString();
  }

  String getDistance() {
    final packageDistance =
        Provider.of<Directions>(context, listen: false).packageDistance;
    num meters = packageDistance
        .firstWhere((pd) => pd.packageId == widget.package.id)
        .distance;
    return meters.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final courierId =
        Provider.of<Functionality>(context, listen: false).courierId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.isOnly
          ? 200
          : _expanded
              ? 330
              : 220,
      child: Card(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            widget.isOnly || _expanded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      )),
                                  onPressed: () =>
                                      {updatePackage(courierId, true)},
                                  child: const Icon(
                                    Icons.check,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      )),
                                  onPressed: () =>
                                      {updatePackage(courierId, false)},
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      side: const BorderSide(
                                          width: 5, color: Colors.blue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      )),
                                  onPressed: () => {onCallClick()},
                                  child: const Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      side: const BorderSide(
                                          width: 5, color: Colors.blue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      )),
                                  onPressed: () => {onMessageClick()},
                                  child: const Icon(
                                    Icons.message,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            !widget.isOnly
                ? _expanded
                    ? const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'UWAGI:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
            !widget.isOnly
                ? _expanded
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              widget.package.comments == ''
                                  ? 'Brak'
                                  : widget.package.comments,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      const Text('Adres:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        '${widget.package.receiver.firstName} ${widget.package.receiver.lastName}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        widget.package.receiver.street,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${widget.package.receiver.postCode} ${widget.package.receiver.city}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Tel: ${widget.package.receiver.phoneNumber}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            const Text('Nr przesyłki:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              widget.package.packageNumber,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${getTime()} min',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Text(
                        '${getDistance()} m',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            !widget.isOnly
                ? IconButton(
                    iconSize: 75,
                    icon: Icon(
                      _expanded
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
