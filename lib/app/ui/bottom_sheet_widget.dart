import 'package:flutter/material.dart';

Future<T?> showMyBottomSheet<T>({
  required BuildContext context,
  Widget? title,
  required Widget child,
  bool isClosable = true,
  bool useCustomLayout = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(178),
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    useSafeArea: true,
    builder: (BuildContext context) {
      if (useCustomLayout) return child;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isClosable) ...[
            _close(context),
            const SizedBox(height: 16),
          ],
          Flexible(
            child: BfiBottomSheetLayout(
              title: title,
              isClosable: false,
              child: child,
            ),
          ),
        ],
      );
    },
  );
}

Widget _close(BuildContext context) {
  return Row(
    children: [
      const Spacer(),
      Material(
        key: const Key('close_button'),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.close, color: Colors.black),
          ),
        ),
      ),
      const SizedBox(width: 20),
    ],
  );
}

class BfiBottomSheetLayout extends StatelessWidget {
  const BfiBottomSheetLayout({
    super.key,
    this.title,
    this.isClosable = true,
    required this.child,
  });

  final Widget? title;
  final Widget child;
  final bool isClosable;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('bottom_sheet'),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isClosable) ...[
          _close(context),
          const SizedBox(height: 16),
        ],
        Flexible(
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        child: title!,
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}