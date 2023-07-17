import 'dart:convert';

import 'package:dhbworld_flutter/ui/utilities/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapController extends GetxController {

  final List<DropdownMenuEntry<String>> roomList = <DropdownMenuEntry<String>>[];

  final List<DropdownMenuEntry<String>> entranceList = <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: "1", label: "main_entrance".tr),
    DropdownMenuEntry(value: "2", label: "south_entrance".tr),
    DropdownMenuEntry(value: "3", label: "north_entrance".tr)
  ];

  final TextEditingController roomController = TextEditingController();
  final TextEditingController entranceController = TextEditingController();

  final selectedRoom = "".obs;
  final selectedEntrance = "".obs;

  Map<String, dynamic>? filemapMap;
  final mapImage = Rxn<AssetImage>();

  MapController() {
    init();
  }

  init() async {
    await initializeRoomList();
  }

  initializeRoomList() async {
    roomList.clear();
    String filemap = await rootBundle.loadString('lib/assets/map/filemap.json');
    filemapMap = jsonDecode(filemap);
    for (String key in filemapMap!.keys) {
      roomList.add(DropdownMenuEntry(value: filemapMap![key]!, label: key.replaceAll(".png", "")));
    }
  }

  showMap() async {
    String prefix = "";
    if (selectedEntrance.value == "2") {
      prefix = "L";
    } else if (selectedEntrance.value == "3") {
      prefix = "R";
    }

    try {
      await rootBundle.load('lib/assets/map/images/$prefix${selectedRoom.value}');
      mapImage(AssetImage('lib/assets/map/images/$prefix${selectedRoom.value}'));
    } catch(_) {
      mapImage.value = null;
      Snackbar.create("no_map_available".tr);
    }
  }
}