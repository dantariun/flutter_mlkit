class ActionModel {
  List<String> actionModels = [];
  final List<String> excludeAction = ["face", "frontal"];
  final List<String> includeAction = [
    "anyEyeClose",
    "mouseSmile",
    // "twoEyeBrowDown"
  ];

  ActionModels currrnt = ActionModels.face;

  String orderString() {
    return map[currrnt] ?? "";
  }

  ActionModels current() {
    print("ActionModels current() $currrnt");
    return currrnt;
  }

  ActionModels randomAction() {
    if (actionModels.isEmpty) {
      final req = includeAction;
      req.shuffle();
      const models = ActionModels.values;

      var filterdNames =
          models.where((element) => !includeAction.contains(element.name));
      filterdNames = filterdNames
          .where((element) => !excludeAction.contains(element.name));
      var filtered = filterdNames.toList();
      filtered.shuffle();

      actionModels.add(req[0]);
      actionModels.add(filtered[0].name);
      actionModels.add(filtered[1].name);

      actionModels.add(req[1]);
      actionModels.add(filtered[2].name);
      actionModels.add(filtered[3].name);

      // actionModels.add(req[2]);
      actionModels.add(filtered[4].name);
      actionModels.add(filtered[5].name);
    }
    print("actionModels : $actionModels");
    currrnt = ActionModels.getByCode(actionModels[0]);
    actionModels.removeAt(0);
    print("currrnt : $currrnt");

    return currrnt;
  }

  Map<ActionModels, String> map = {
    ActionModels.face: "Take a photo of your face",
    ActionModels.frontal: "Look straight ahead",
    ActionModels.uptoward: "Please tilt your head up",
    ActionModels.downtoward: "Please look down",
    ActionModels.rightRotate: "Please turn your head to the right",
    ActionModels.leftRotate: "Please turn your head to the left",
    ActionModels.rightTilt: "Please lean your head to the right",
    ActionModels.leftTilt: "Please lean your head to the left",
    ActionModels.mouseSmile: "Please smile",
    ActionModels.mouseOpend: "Please open your mouth",
    ActionModels.anyEyeClose: "Please close your eyes",
  };
}

enum ActionModels {
  face([-1, -1, -1, -1, -1, -1]),
  frontal([-1, 0, 0, -1, -1, -1]),
  uptoward([2, -1, -1, -1, -1, -1]),
  downtoward([1, -1, -1, -1, -1, -1]),
  rightRotate([-1, 2, -1, -1, -1, -1]),
  leftRotate([-1, 1, -1, -1, -1, -1]),
  rightTilt([-1, -1, 2, -1, -1, -1]),
  leftTilt([-1, -1, 1, -1, -1, -1]),
  mouseSmile([-1, 0, 0, -1, 2, -1]),
  mouseOpend([-1, 0, 0, -1, 1, -1]),
  anyEyeClose([-1, 0, 0, 1, -1, -1]);

  final List<int> list;

  const ActionModels(this.list);

  factory ActionModels.getByCode(String name) {
    return ActionModels.values.firstWhere((value) => value.name == name);
  }
}
