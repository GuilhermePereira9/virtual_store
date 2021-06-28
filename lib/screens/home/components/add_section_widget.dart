import 'package:flutter/material.dart';
import 'package:virtual_store/models/home_manager.dart';
import 'package:virtual_store/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget(this.homeManager);

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: TextButton(
          onPressed: () {
            homeManager.addSection(Section(type: 'List'));
          },
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          child: const Text('Adicionar Lista'),
        )),
        Expanded(
            child: TextButton(
          onPressed: () {
            homeManager.addSection(Section(type: 'Staggered'));
          },
          style: TextButton.styleFrom(
            primary: Colors.white,
          ),
          child: const Text('Adicionar Grade'),
        )),
      ],
    );
  }
}
