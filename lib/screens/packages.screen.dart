import 'package:courier_app/providers/functionality.dart';
import 'package:courier_app/providers/packages.dart';
import 'package:courier_app/widgets/appDrawer.dart';
import 'package:courier_app/widgets/endButton.dart';
import 'package:courier_app/widgets/package.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PackagesScreen extends StatefulWidget {
  static const name = '/packages';

  const PackagesScreen({Key? key}) : super(key: key);

  @override
  PackagesScreenState createState() => PackagesScreenState();
}

class PackagesScreenState extends State<PackagesScreen> {
  late Future _packagesFuture;
  late String _courierId;
  Future _obtainPackagesFuture(String courierId) {
    return Provider.of<Packages>(context, listen: false).getPackages(courierId);
  }

  String _obtainCourierId() {
    return Provider.of<Functionality>(context, listen: false).courierId;
  }

  @override
  void initState() {
    _courierId = _obtainCourierId();
    _packagesFuture = _obtainPackagesFuture(_courierId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 20, top: 0),
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                size: 50,
                color: Colors.blue,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        shadowColor: null,
      ),
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 180,
          child: FutureBuilder(
            future: _packagesFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  return const Center(child: Text('Error Occured'));
                } else {
                  return Consumer<Packages>(
                    builder: (ctx, packageData, child) => ListView.builder(
                      itemCount: packageData.packages.length,
                      itemBuilder: (ctx, i) =>
                          PackageWidget(packageData.packages[i], false),
                    ),
                  );
                }
              }
            },
          ),
        ),
        const EndButton(),
      ]),
    );
  }
}
