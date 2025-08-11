import 'package:flutter/material.dart';

class VoteButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onPressed;

  const VoteButton({super.key, required this.onPressed, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(selected ? 'Voted' : 'Vote'),
    );
  }
}
