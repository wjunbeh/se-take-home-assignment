import 'dart:async';
import 'package:flutter/foundation.dart';
import 'order.dart';

class Bot {
  final int id;
  final Function(Order) onComplete;
  bool _isActive = true;
  final ValueNotifier<Order?> processingOrderNotifier = ValueNotifier(null);
  final ValueNotifier<int?> remainingSecondsNotifier = ValueNotifier(null);

  Bot(this.id, {required this.onComplete});

  void start(List<Order> pendingOrders) async {
    while (_isActive) {
      if (pendingOrders.isNotEmpty) {
        final order = pendingOrders.removeAt(0);
        processingOrderNotifier.value = order;
        remainingSecondsNotifier.value = 10;

        // Count down for 10 seconds
        while (remainingSecondsNotifier.value! > 0 && _isActive) {
          await Future.delayed(const Duration(seconds: 1));
          remainingSecondsNotifier.value = remainingSecondsNotifier.value! - 1;
        }

        if (_isActive) {
          onComplete(order);
          processingOrderNotifier.value = null;
          remainingSecondsNotifier.value = null;
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  void stop() {
    _isActive = false;
  }
}