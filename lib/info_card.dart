import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.moves,
    Key? key,
  }) : super(key: key);

  final int moves;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Temukan 8 pasangan gambar!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Langkah: $moves'),
      ],
    );
  }
}
