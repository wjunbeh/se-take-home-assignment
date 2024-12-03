import 'package:flutter/material.dart';
import 'package:mcd/color.dart';
import 'class/bot.dart';
import 'class/order.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  int orderCounter = 1;
  List<Order> pendingOrders = [];
  List<Order> completedOrders = [];
  List<Bot> bots = [];
  int botCounter = 0;

  void addOrder(String role) {
    setState(() {
      if (role == "vip") {
        int vipIndex = pendingOrders.indexWhere((order) => order.role != "vip");
        pendingOrders.insert(
          vipIndex == -1 ? pendingOrders.length : vipIndex,
          Order(orderCounter++, role),
        );
      } else {
        pendingOrders.add(Order(orderCounter++, role));
      }
    });
  }

  void addBot() {
    setState(() {
      botCounter++;
      Bot bot = Bot(
        botCounter,
        onComplete: (Order order) {
          setState(() {
            completedOrders.add(order);
            pendingOrders.remove(order);
          });
        },
      );
      bots.add(bot);
      bot.start(pendingOrders);
    });
  }

  void removeBot() {
    if (bots.isNotEmpty) {
      setState(() {
        Bot bot = bots.removeLast();
        if (bot.processingOrderNotifier.value != null) {
          final returnedOrder = bot.processingOrderNotifier.value!;
          int lastVipIndex =
          pendingOrders.lastIndexWhere((order) => order.role == "vip");
          int insertIndex = lastVipIndex + 1;
          pendingOrders.insert(insertIndex, returnedOrder);
        }
        bot.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 5),
            Image.asset(
              'lib/images/mcd_logo.png',
              height: 40,
            ),
            const SizedBox(width: 15), // Add spacing between the image and text
            Text(
              'McDonald\'s',
              style: TextStyle(
                fontSize: 32,
                color: themeColors,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColors,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Bot Summary Section
            SizedBox(
              height: 220,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Image.asset(
                                'lib/images/bot.png',
                                height: 25,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                'Total Bots: ${bots.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: addBot,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  minimumSize: const Size(36, 36),
                                  shape: const CircleBorder(), // Makes the button circular
                                ),
                                child: const Icon(Icons.add, size: 20),
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: removeBot,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8.0),
                                  minimumSize: const Size(36, 36),
                                  shape: const CircleBorder(), // Makes the button circular
                                ),
                                child: const Icon(Icons.remove, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView.builder(
                          itemCount: bots.length,
                          itemBuilder: (context, index) {
                            final bot = bots[index];
                            return ValueListenableBuilder<Order?>(
                              valueListenable: bot.processingOrderNotifier,
                              builder: (context, processingOrder, child) {
                                return ValueListenableBuilder<int?>(
                                  valueListenable: bot.remainingSecondsNotifier,
                                  builder: (context, remainingSeconds, child) {
                                    return Card(
                                      elevation: 2,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: Text('${bot.id}'),
                                        ),
                                        title: Text(
                                          'Bot #${bot.id}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        subtitle: processingOrder != null
                                            ? Text(
                                          'Processing Order #${processingOrder.id} (${processingOrder.role.toUpperCase()})\n'
                                              'Remaining Seconds: ${remainingSeconds ?? 0}',
                                          style: TextStyle(fontSize: 12, color: themeColors),
                                        )
                                            : const Text(
                                          'Idle',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              child: Row(
                                children: [
                                const SizedBox(width: 2),
                                Image.asset(
                                  'lib/images/pending.png',
                                  height: 25,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Pending Orders',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: ListView.builder(
                                itemCount: pendingOrders.length,
                                itemBuilder: (context, index) {
                                  final order = pendingOrders[index];
                                  return SizedBox(
                                    height: 80,
                                    child: Card(
                                      elevation: 4,
                                      child: ListTile(
                                        title: Text('Order #${order.id}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        subtitle: Text(order.role.toUpperCase(), style: const TextStyle(fontSize: 11)),
                                        leading: Image.asset(
                                          order.role == "vip"
                                              ? 'lib/images/vip.png'
                                              : 'lib/images/normal.png',
                                          width: 32,
                                          height: 35,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Completed Orders
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                const SizedBox(width: 2),
                                Image.asset(
                                  'lib/images/completed.png',
                                  height: 25,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Completed Orders',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(height: 5),
                            Expanded(
                              child: ListView.builder(
                                itemCount: completedOrders.length,
                                itemBuilder: (context, index) {
                                  final order = completedOrders[index];
                                  return Card(
                                    elevation: 2,
                                    child: ListTile(
                                      title: Text('Order #${order.id}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      subtitle: Text(order.role.toUpperCase(), style: const TextStyle(fontSize: 11)),
                                      leading: Image.asset(
                                        order.role == "vip"
                                            ? 'lib/images/vip.png'
                                            : 'lib/images/normal.png',
                                        width: 32,
                                        height: 35,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // Button
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => addOrder("normal"),
                      icon: Image.asset(
                        'lib/images/normal.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text("New Normal Order"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => addOrder("vip"),
                      icon: Image.asset(
                        'lib/images/vip.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text("New VIP Order"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
