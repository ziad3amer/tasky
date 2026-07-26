import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/app_sizes.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/widgets/custtom_svg_picture.dart';
import 'package:tasky/core/widgets/custtom_text_form_field.dart';
import 'package:tasky/features/home/home_screen.dart';
import 'package:tasky/features/navigation/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _kay = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _kay,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CusttomSvgPicture.withColorFilter(
                      path: "lib/assets/images/Vector (1).svg",
                      width: AppSizes.w42,
                      height: AppSizes.h42,
                    ),

                    SizedBox(width: AppSizes.pw8),
                    Text(
                      "Tasky",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.ph100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Tasky ",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(width: AppSizes.pw16),
                    CusttomSvgPicture.withColorFilter(
                      path: "lib/assets/images/waving-hand-.svg",
                      width: AppSizes.w8,
                      height: AppSizes.h8,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.ph12),
                Text(
                  "Your productivity journey starts here.",
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall!.copyWith(fontSize: 16),
                ),
                SizedBox(height: AppSizes.ph24),
                CusttomSvgPicture.withColorFilter(
                  path: "lib/assets/images/pana.svg",
                  width: AppSizes.w200,
                  height: AppSizes.h200,
                ),

                SizedBox(height: AppSizes.ph24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height:AppSizes.ph24 ),
                      CusttomTextFormField(
                        controller: controller,
                        hintText: "e.g. Sarah Khalid",
                        title: "Full Name",
                        validator: (Value) {
                          if (Value == null || Value.trim().isEmpty) {
                            return "Please Enter full Name";
                          }
                        },
                      ),

                      // TextFormField(
                      //   controller: controller ,
                      //   style: TextStyle(color: Colors.white),
                      //   decoration: InputDecoration(
                      //     hintText: "e.g. Sarah Khalid",
                      //     hintStyle: TextStyle(
                      //       color: Color(0xFF6D6D6D),
                      //     ),
                      //
                      //     filled: true,
                      //     fillColor: Color(0xFF282828),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(16),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //   ),
                      //   validator:(Value) {
                      //     if(Value==null || Value.trim().isEmpty)
                      //     {
                      //       return "Please Enter full Name";
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.ph24),
                ElevatedButton(
                  onPressed: () async {
                    if (_kay.currentState?.validate() ?? false) {
                      await PreferencesMangar().setString(
                        StorageKay.username,
                        controller.value.text,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return MainScreen();
                          },
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please Enter full Name")),
                      );
                    }
                  },
                  child: Text(
                    "Let’s Get Started",
                    style: TextStyle(color: Color.fromRGBO(225, 252, 252, 1)),
                  ),
                  style: ElevatedButton.styleFrom(fixedSize: Size(340, 40)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
