import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/widgets/custtom_text_form_field.dart';

class UserDetialsScreen extends StatefulWidget {
  const UserDetialsScreen({
    super.key,
    required this.username,
    required this.motivationQuote,
  });

  final String username;
  final String? motivationQuote;

  @override
  State<UserDetialsScreen> createState() => _UserDetialsScreenState();
}

class _UserDetialsScreenState extends State<UserDetialsScreen> {
  late final TextEditingController userNameController;

  late final TextEditingController motivationQuoteController;

  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> _Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController(text: widget.username);
    motivationQuoteController = TextEditingController(text: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _Key,
          child: Column(
            children: [
              CusttomTextFormField(
                controller: userNameController,
                hintText: "ziad 3mer",
                title: "user Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter user name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CusttomTextFormField(
                controller: motivationQuoteController,
                hintText: 'One task at a time. One step closer.',
                title: StorageKay.MotivationQuote,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Motivation Quote";
                  }
                  return null;
                },
              ),
              Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                onPressed: () async {
                  if (_Key.currentState!.validate()) {
                    await PreferencesMangar().setString(
                      StorageKay.username,
                      userNameController.value.text,
                    );
                    await PreferencesMangar().setString(
                      StorageKay.MotivationQuote,
                      motivationQuoteController.value.text,
                    );
                    Navigator.pop(context, true);
                  }
                },
                label: Text(
                  "Save Changes",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFFFFFCFC),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
