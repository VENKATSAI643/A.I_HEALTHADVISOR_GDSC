import 'package:flutter_application_1/BardModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BardAIController extends GetxController {
  RxList<BardModel> historyList = RxList<BardModel>([
    BardModel(system: "user", message: "What can you do for me"),
    BardModel(system: "bard", message: "What do u want from me"),
  ]);

  RxBool isLoading = false.obs;

  void sendPrompt(String prompt) async {
    isLoading.value = true;

    // Add user prompt to history
    var userHistory = BardModel(system: "user", message: prompt);
    historyList.add(userHistory);
    prompt =
        "Act as Health Advisor and answer only if it is related to health or else say that you can't do it" +
            prompt;
    // Make request to your API
    final msg = "https://r8kx87dz-3000.inc1.devtunnels.ms/Gemini_pro?prompt='" +
        prompt +
        "'";
    final response = await http.get(Uri.parse(msg));

    // Handle the API response
    if (response.statusCode == 200) {
      String newData = response.body;

      // Add bard response to history
      var bardHistory = BardModel(system: "bard", message: newData);
      historyList.add(bardHistory);

      // Print bard response
      print(newData);
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    // Set loading to false after all operations
    isLoading.value = false;
  }

  Future<void> callGeminiProVision(File imageFile) async {
    isLoading.value = true;

    final url =
        Uri.parse("https://r8kx87dz-3000.inc1.devtunnels.ms/Gemini_pro_vision");

    // Create a MultipartRequest
    final request = http.MultipartRequest('POST', url);

    // Add image as multipart file
    final imagePart =
        await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(imagePart);

    // Add other necessary headers (e.g., authentication)
    // ...

    try {
      // Send the request
      final response = await request.send();

      // Read response as a string
      final responseData = await response.stream.bytesToString();
      var bardHistory = BardModel(system: "bard", message: responseData);
      historyList.add(bardHistory);

      // Handle API response as before
      // ...
    } catch (error) {
      // Handle errors gracefully
      // ...
    } finally {
      isLoading.value = false;
    }
  }

  File? _image;

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _image = File(pickedImage.path);
      callGeminiProVision(_image!);
    } else {
      print('No image selected.');
    }
  }
}
