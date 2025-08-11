import 'package:flutter/material.dart';
import 'vote_button.dart';

class PollOptionList extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final int? selectedOption;
  final void Function(int optionId) onVote;

  const PollOptionList({
    super.key,
    required this.options,
    required this.onVote,
    this.selectedOption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((o) {
        final id = o['id'] as int? ?? 0;
        final text = o['text'] as String? ?? '';
        final votes = o['votes'] as List<dynamic>? ?? [];
        final selected = selectedOption == id;
        return ListTile(
          title: Text('$text (${votes.length})'),
          trailing: VoteButton(
            selected: selected,
            onPressed: () => onVote(id),
          ),
        );
      }).toList(),
    );
  }
}
