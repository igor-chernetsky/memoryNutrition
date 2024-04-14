import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/game_provider.dart';
import 'package:memory_nutration/providers/global_provider.dart';

class HintBlock extends ConsumerWidget {
  String text;
  HintBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(children: [
      Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.7),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 20, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      Positioned(
        top: -10,
        right: -10,
        child: IconButton(
            onPressed: () => ref.read(globalProvider.notifier).toggleHints(),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).primaryColor,
            )),
      ),
    ]);
  }
}
