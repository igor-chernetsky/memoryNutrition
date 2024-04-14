import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_nutration/providers/game_provider.dart';

class SizeSettingsWidget extends ConsumerWidget {
  final String playground;
  SizeSettingsWidget({super.key, required this.playground});

  getPlaygroundsRow(BuildContext context, WidgetRef ref) {
    int selectedSize = ref.watch(gameProvider).size;
    double width = MediaQuery.of(context).size.width / 2 - 40;
    if (width > 120) {
      width = 120;
    }
    return Row(
      children: [3, 4]
          .map((size) => SizedBox(
                width: width,
                height: width,
                child: GestureDetector(
                  onTap: () => ref.read(gameProvider.notifier).changeSize(size),
                  child: Card(
                    child: Opacity(
                      opacity: selectedSize == size ? 1 : 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(7.0)),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/img/$playground/cards$size.png'),
                                fit: BoxFit.contain)),
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
