import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenhouse_app/domain/pair.dart';

class ZoneSizeSelector extends StatefulWidget {
  final void Function(String value)? onHeightChanged;
  final void Function(String value)? onWidthChanged;
  final Pair<double>? definitions;

  const ZoneSizeSelector({
    super.key,
    this.onHeightChanged,
    this.onWidthChanged,
    this.definitions,
  });

  @override
  State<ZoneSizeSelector> createState() => _ZoneSizeSelectorState();
}

class _ZoneSizeSelectorState extends State<ZoneSizeSelector> {
  late TextEditingController widthFieldController;
  late TextEditingController heightFieldController;

  @override
  void initState() {
    super.initState();
    widthFieldController = TextEditingController(
      text: '${widget.definitions?.first.toDouble() ?? 10.0}',
    );
    heightFieldController = TextEditingController(
      text: '${widget.definitions?.second.toDouble() ?? 10.0}',
    );
  }

  @override
  void didUpdateWidget(ZoneSizeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.definitions?.first != widget.definitions?.first) {
      widthFieldController.text = '${widget.definitions?.first.toDouble() ?? 10.0}';
    }
    if (oldWidget.definitions?.second != widget.definitions?.second) {
      heightFieldController.text = '${widget.definitions?.second.toDouble() ?? 10.0}';
    }
  }

  @override
  void dispose() {
    widthFieldController.dispose();
    heightFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final textFieldWidth = width / 2 - 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Zone Size'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: textFieldWidth,
              child: TextField(
                controller: widthFieldController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(label: Text('width')),
                onSubmitted: widget.onWidthChanged,
              ),
            ),
            const Text('x'),
            SizedBox(
              width: textFieldWidth,
              child: TextField(
                controller: heightFieldController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: const InputDecoration(label: Text('height')),
                onSubmitted: widget.onHeightChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
