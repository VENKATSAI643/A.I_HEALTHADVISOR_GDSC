import 'package:flutter_application_1/BardAIController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Use it in your code

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BardAIController controller = Get.put(BardAIController());
    TextEditingController textField = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xfff2f1f9),
      appBar: AppBar(
        centerTitle: true,
        leading: Image.asset(
          'assets/healthlogomain.png',
          fit: BoxFit.fitWidth,
          height: 100,
          width: 200,
        ),
        title: const Text(
          "Health Advisor AI",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              controller.sendPrompt("Hello what can you do for me ");
            },
            icon: const Icon(Icons.security),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Obx(() => Column(
                        children: controller.historyList
                            .map(
                              (e) => Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text(e.system == "user" ? "👨‍💻" : "🤖"),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(e.message ?? '')),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ))
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: textField,
                      decoration: const InputDecoration(
                        hintText: "You can ask what you want",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.getImage();
                            // Handle gallery icon onPressed
                            // You can implement gallery functionality here
                          },
                          icon: const Icon(
                            Icons.photo,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : IconButton(
                                onPressed: () {
                                  if (textField.text.isNotEmpty) {
                                    controller.sendPrompt(textField.text);
                                    textField.clear();
                                  }
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
