import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/sidebar_mascot_controller.dart';

class SidebarMascot extends StatefulWidget {
  const SidebarMascot({super.key});

  @override
  State<SidebarMascot> createState() => _SidebarMascotState();
}

class _SidebarMascotState extends State<SidebarMascot> {
  String currentAsset = 'bro';
  Timer? actionTimer;
  Timer? idleTimer;

  late SidebarMascotController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<SidebarMascotController>();

    controller.addListener(_onMascotCommand);

    idleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (now.difference(controller.lastActivity).inSeconds > 15 &&
          currentAsset != 'tired_bro') {
        _playOnce('tired_bro');
      }
    });
  }

  void _onMascotCommand() {
    final newState = controller.current;
    print('[MascotWidget] received command → $newState'); // 🔥 лог!
    if (newState == 'basic_bro' || newState == 'reading_bro') {
      _playOnce(newState);
    } else if (newState == 'bro') {
      _setStatic('bro');
    }
  }

  void _playOnce(String gifName) {
    print('🔥 [_playOnce] triggered with $gifName');
    controller.markActivity();

    setState(() {
      currentAsset = gifName;
    });

    actionTimer?.cancel();
    actionTimer = Timer(const Duration(seconds: 3), () async {
      // 1. сброс до пустоты
      setState(() {
        currentAsset = '';
      });

      // 2. дождаться кадра, чтобы реально отрисовалось
      await Future.microtask(() {});
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        // 3. возвращаем bro
        setState(() {
          currentAsset = 'bro';
        });
      }
    });
  }

  void _setStatic(String assetName) {
    actionTimer?.cancel();
    setState(() {
      currentAsset = assetName;
    });
  }

  @override
  void dispose() {
    controller.removeListener(_onMascotCommand);
    idleTimer?.cancel();
    actionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isStatic = currentAsset == 'bro';
    final ext = isStatic ? '.png' : '.gif';
    final path = currentAsset.isEmpty
        ? null
        : 'assets/mascot/$currentAsset$ext';

    return Positioned(
      left: 8,
      bottom: 8,
      child: IgnorePointer(
        child: SizedBox(
          width: 200,
          height: 200,
          child: path != null
              ? Image.asset(
                  path,
                  key: UniqueKey(), // 💣 принудительный rebuild
                  fit: BoxFit.contain,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
