import 'package:flutter/material.dart';
import 'package:plumora/ui/theme/plumora_ui.dart';
import 'package:stacked/stacked.dart';

import 'plumora_fab_model.dart';
import 'package:flutter/material.dart';

class PlumoraFab extends StatelessWidget {
  final VoidCallback onTap;
  const PlumoraFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [PlumoraUi.gold1, PlumoraUi.gold2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}
