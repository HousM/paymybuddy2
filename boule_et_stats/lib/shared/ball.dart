// SFD §10 (boule signature) + RG-T1 (couleurs) + §9 accessibilité (label "numéro X").

import 'package:flutter/material.dart';

import '../core/theme.dart';

enum BallKind { main, star, chance }

class Ball extends StatelessWidget {
  const Ball({
    super.key,
    required this.number,
    this.kind = BallKind.main,
    this.size = 44,
    this.dim = false,
  });

  final int number;
  final BallKind kind;
  final double size;
  final bool dim;

  Color get _baseColor {
    switch (kind) {
      case BallKind.main:
        return Colors.white;
      case BallKind.star:
        return AppColors.or;
      case BallKind.chance:
        return AppColors.rouge;
    }
  }

  Color get _textColor {
    switch (kind) {
      case BallKind.main:
        return AppColors.nuit;
      case BallKind.star:
        return const Color(0xFF3A2400);
      case BallKind.chance:
        return Colors.white;
    }
  }

  Color _shade(Color c) => Color.fromARGB(
        c.alpha,
        (c.red - 90).clamp(0, 255),
        (c.green - 90).clamp(0, 255),
        (c.blue - 90).clamp(0, 255),
      );

  String get _semanticLabel {
    switch (kind) {
      case BallKind.main:
        return 'numéro $number';
      case BallKind.star:
        return 'étoile $number';
      case BallKind.chance:
        return 'numéro chance $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = _baseColor;
    final ball = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.36, -0.44),
          radius: 0.9,
          colors: [Colors.white, base, _shade(base)],
          stops: const [0.0, 0.45, 1.0],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x73000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Text(
            '$number',
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.w800,
              fontSize: size * 0.4,
              fontFamily: 'BricolageGrotesque',
              height: 1.0,
            ),
          ),
          if (kind == BallKind.star)
            Positioned(
              top: -2,
              right: -2,
              child: Text(
                '★',
                style: TextStyle(
                  color: AppColors.or,
                  fontSize: size * 0.3,
                  shadows: const [Shadow(color: Colors.black45, blurRadius: 3)],
                ),
              ),
            ),
        ],
      ),
    );

    return Semantics(
      label: _semanticLabel,
      excludeSemantics: true,
      child: Opacity(opacity: dim ? 0.35 : 1.0, child: ball),
    );
  }
}
