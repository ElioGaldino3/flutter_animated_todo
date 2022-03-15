import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rive/rive.dart';

class CustomCheckbox extends HookWidget {
  final bool value;
  final String? title;
  final Function(bool value)? onChanged;
  const CustomCheckbox({Key? key, required this.value, this.onChanged, this.title}) : super(key: key);

  Future<Artboard?> loadBundle() async {
    final data = await rootBundle.load('assets/checkbox.riv');
    final file = RiveFile.import(data);
    return file.mainArtboard;
  }

  @override
  Widget build(BuildContext context) {
    Artboard? artboard;
    SMIInput<bool>? checkboxAnimation;

    Future<void> loadBundle() async {
      final data = await rootBundle.load('assets/checkbox.riv');
      final file = RiveFile.import(data);
      final _artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(_artboard, 'CheckboxMachine');

      if (controller != null) {
        controller.findInput<bool>('Pressed')?.value = value;
        checkboxAnimation = controller.findInput<bool>('Pressed');
        _artboard.addController(controller);

        artboard = _artboard;
      }
    }

    final animationController = useAnimationController(duration: const Duration(milliseconds: 400));
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    final lengthAnimation = Tween<double>(begin: 0, end: 1.0).animate(curve);

    return FutureBuilder(
        future: loadBundle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const SizedBox();

          return GestureDetector(
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Rive(artboard: artboard!, fit: BoxFit.cover),
                ),
                if (title != null) const SizedBox(width: 8),
                if (title != null)
                  Stack(
                    children: [
                      Text(title!),
                      ValueListenableBuilder<double>(
                          valueListenable: lengthAnimation,
                          builder: (context, length, widget) {
                            return Container(
                              transform: Matrix4.identity()..scale(length, 1.0),
                              child: Text(
                                title!,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.transparent,
                                  decorationColor: Colors.black,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            );
                          })
                    ],
                  ),
              ],
            ),
            onTap: () {
              checkboxAnimation?.value = !(checkboxAnimation?.value ?? true);
              if (onChanged != null) onChanged!(checkboxAnimation?.value ?? false);
              if (checkboxAnimation?.value ?? false) {
                animationController.forward();
              } else {
                animationController.reverse();
              }
            },
          );
        });
  }
}
