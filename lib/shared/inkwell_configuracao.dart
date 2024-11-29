import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget inkwellConfiguracao(
    {required BuildContext context,
    required String text,
    required Widget? widget,
    IconData? icon,
    String? subtitle,
    Future<void> Function()? user}) {
  return InkWell(
    onTap: () async {
      if (text == "Sair" && user != null) {
        await user();
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => widget!));
    },
    child: Row(
      children: [
        FaIcon(
          icon,
          size: 18,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
