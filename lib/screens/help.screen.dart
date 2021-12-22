// ignore_for_file: must_be_immutable

import 'package:courier_app/widgets/appDrawer.dart';
import 'package:courier_app/widgets/instruction.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  static const name = '/help';

  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  PageController controller = PageController();
  double? currentPageValue = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              size: 40,
              color: Colors.blue,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: PageView(controller: controller, children: const [
              Instruction('Ekran Logowania',
                  'assets/instructions/courierLoginInstruction.png'),
              Instruction('Ekran Rozpoczęcia Pracy',
                  'assets/instructions/courierStartWorkInstruction.png'),
              Instruction('Ekran Nawigacji',
                  'assets/instructions/courierMapInstruction.png'),
              Instruction('Menu Poboczne',
                  'assets/instructions/courierSidebarInstruction.png'),
              Instruction('Ekran Przesyłek',
                  'assets/instructions/courierPackagesInstruction.png'),
            ]),
          ),
          Text(
            'strona ${currentPageValue!.floor() + 1} z 5',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
