import 'package:flutter/material.dart';
import 'package:plumora/ui/theme/plumora_ui.dart';
import 'package:stacked/stacked.dart';

import 'plumora_moon_button_model.dart';

import 'package:flutter/material.dart';

class PlumoraMoonButton extends StatelessWidget {
  const PlumoraMoonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PlumoraUi.gold1, PlumoraUi.gold2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child:
          const Icon(Icons.dark_mode_outlined, color: Colors.white, size: 20),
    );
  }
}
