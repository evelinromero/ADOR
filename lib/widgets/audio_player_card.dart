import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

/// Reproductor sencillo para una URL de audio (mp3, m4a...).
class AudioPlayerCard extends StatefulWidget {
  final String url;
  const AudioPlayerCard({super.key, required this.url});

  @override
  State<AudioPlayerCard> createState() => _AudioPlayerCardState();
}

class _AudioPlayerCardState extends State<AudioPlayerCard> {
  final _player = AudioPlayer();
  final _subs = <StreamSubscription>[];
  PlayerState _state = PlayerState.stopped;
  Duration _pos = Duration.zero;
  Duration _dur = Duration.zero;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _subs.addAll([
      _player.onPlayerStateChanged.listen((s) => setState(() => _state = s)),
      _player.onPositionChanged.listen((p) => setState(() => _pos = p)),
      _player.onDurationChanged.listen((d) => setState(() => _dur = d)),
    ]);
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_state == PlayerState.playing) {
      await _player.pause();
      return;
    }
    if (_state == PlayerState.paused) {
      await _player.resume();
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _player.play(UrlSource(widget.url));
    } catch (_) {
      _error = 'No se pudo reproducir el audio. Revisa el enlace.';
    }
    if (mounted) setState(() => _loading = false);
  }

  String _fmt(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final max = _dur.inMilliseconds.toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
        child: Column(
          children: [
            Row(children: [
              IconButton.filled(
                iconSize: 32,
                style: IconButton.styleFrom(backgroundColor: kAccent),
                onPressed: _loading ? null : _toggle,
                icon: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(_state == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow),
              ),
              Expanded(
                child: Slider(
                  value: max <= 0
                      ? 0
                      : _pos.inMilliseconds.toDouble().clamp(0, max),
                  max: max <= 0 ? 1 : max,
                  onChanged: max <= 0
                      ? null
                      : (v) =>
                          _player.seek(Duration(milliseconds: v.toInt())),
                ),
              ),
              Text('${_fmt(_pos)} / ${_fmt(_dur)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
          ],
        ),
      ),
    );
  }
}
