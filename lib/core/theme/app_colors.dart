import 'package:flutter/material.dart';

/// Brand colour palette — mirrors the HTML CSS custom properties.
abstract final class AppColors {
  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const bgDark = Color(0xFF1A1A1A);
  static const bgMid = Color(0xFF2D2D2D);
  static const bgCard = Color(0xFF242424);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const cream = Color(0xFFF5F0E8);
  static const creamDim = Color(0xFFE8DFD0);
  static const creamMuted = Color(0xFFB8AD9E);

  // ── Accent ───────────────────────────────────────────────────────────────
  static const accent = Color(0xFFE8845A);
  static const accentDeep = Color(0xFFD4614A);

  // ── Borders ──────────────────────────────────────────────────────────────
  /// rgba(245,240,232,0.08) — subtle cream outline
  static const border = Color(0x14F5F0E8);

  /// rgba(232,132,90,0.30) — accent-tinted outline
  static const borderAccent = Color(0x4DE8845A);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const error = Color(0xFFCF6679);
  static const errorContainer = Color(0xFF3D1520);
}
