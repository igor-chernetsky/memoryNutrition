import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/models/game.dart';
import 'package:memory_nutration/providers/global_provider.dart';

class SettingsWidget extends ConsumerWidget {
  const SettingsWidget({super.key});

  getPlaygroundsRow(BuildContext context, WidgetRef ref) {
    GameSettings settings = ref.watch(globalProvider);
    double width = MediaQuery.of(context).size.width / 2 - 40;
    if (width > 120) {
      width = 120;
    }
    return Row(
      children: ['wood', 'sea', 'crown']
          .map((name) => SizedBox(
                width: width,
                height: width,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(globalProvider.notifier).setPlayground(name),
                  child: Card(
                    child: Opacity(
                      opacity: name == settings.playground ? 1 : 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7.0)),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/img/$name/playground.jpg'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Card(
          color: const Color.fromRGBO(255, 255, 255, 0.8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Playground',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 24,
                    color: const Color(0xFF04946d),
                  ),
            ),
          ),
        ),
        getPlaygroundsRow(context, ref)
      ],
    );
  }
}
