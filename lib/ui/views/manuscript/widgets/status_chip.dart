import 'package:flutter/material.dart';
import '../../../../models/manuscript.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({required this.status, Key? key}) : super(key: key);

  String _label() {
    switch (status) {
      case ManuscriptStatus.writing:
        return 'En cours d’écriture';
      case ManuscriptStatus.editing:
        return 'Édition';
      case ManuscriptStatus.reviewing:
        return 'Bêta-lecture';
      case ManuscriptStatus.selected:
        return 'Sélectionné';
      case ManuscriptStatus.published:
        return 'Publié';
      default:
        return status;
    }
  }

  Color _color() {
    switch (status) {
      case ManuscriptStatus.writing:
        return const Color(0xFFE57C8C);
      case ManuscriptStatus.editing:
        return const Color(0xFFFBC02D);
      case ManuscriptStatus.reviewing:
        return const Color(0xFF64B5F6);
      case ManuscriptStatus.selected:
        return const Color(0xFFAB47BC);
      case ManuscriptStatus.published:
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFFB0BEC5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: _color().withOpacity(0.9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
