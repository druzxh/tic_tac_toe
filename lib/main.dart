import 'package:flutter/material.dart';

import 'images_card.dart';
import 'info_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xfff4f6fb),
      ),
      home: const MemoryGamePage(),
    );
  }
}

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  final Game _game = Game();
  final Set<int> _matchedCards = <int>{};
  int? _firstCard;
  bool _isChecking = false;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    setState(() {
      _game.initGame();
      _matchedCards.clear();
      _firstCard = null;
      _isChecking = false;
      _moves = 0;
    });
  }

  bool _isVisible(int index) {
    return _matchedCards.contains(index) || _firstCard == index;
  }

  Future<void> _selectCard(int index) async {
    if (_isChecking || _isVisible(index)) {
      return;
    }

    if (_firstCard == null) {
      setState(() => _firstCard = index);
      return;
    }

    final int firstCard = _firstCard!;
    setState(() {
      _isChecking = true;
      _moves++;
    });

    if (_game.gameImg[firstCard] == _game.gameImg[index]) {
      setState(() {
        _matchedCards.addAll(<int>[firstCard, index]);
        _firstCard = null;
        _isChecking = false;
      });
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) {
      return;
    }
    setState(() {
      _firstCard = null;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isComplete = _matchedCards.length == _game.gameImg.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: _newGame,
            tooltip: 'Mulai ulang',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              InfoCard(moves: _moves),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: _game.gameImg.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final bool visible = _isVisible(index);
                    return Semantics(
                      label: visible
                          ? 'Kartu gambar ${index + 1}'
                          : 'Kartu tertutup ${index + 1}',
                      button: true,
                      child: GestureDetector(
                        onTap: () => _selectCard(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: visible ? Colors.white : Colors.indigo,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: visible
                                  ? Colors.indigo
                                  : Colors.indigo.shade700,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: visible
                                ? _game.gameImg[index] is String
                                    ? Image.asset(
                                        _game.gameImg[index] as String,
                                        width: 44,
                                        height: 44,
                                      )
                                    : Icon(
                                        _game.gameImg[index] as IconData,
                                        size: 36,
                                        color: Colors.indigo,
                                      )
                                : Image.asset(
                                    Game.hiddenCardPath,
                                    width: 44,
                                    height: 44,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isComplete) ...<Widget>[
                const SizedBox(height: 12),
                const Text(
                  'Selamat! Semua pasangan ditemukan.',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _newGame,
                  child: const Text('Main Lagi'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
