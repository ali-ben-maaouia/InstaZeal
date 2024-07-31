import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/features/home/screens/login/login.dart';
import 'package:insta_clone/utils/backgroun2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Setting> settings2 = [
      Setting(
        title: "FAQ",
        icon: CupertinoIcons.ellipsis_vertical_circle_fill,
        color: Color(0xff212C42),
        onPressed: () {
          print("FAQ tapped");
          // Add your navigation logic here
        },
      ),
      Setting(
        title: "Our Handbook",
        icon: CupertinoIcons.pencil_circle_fill,
        color: Color(0xff212C42),
        onPressed: () {
          print("Our Handbook tapped");
          // Add your navigation logic here
        },
      ),
      Setting(
        title: "Community",
        icon: CupertinoIcons.person_3_fill,
        color: Color(0xff212C42),
        onPressed: () {
          print("Community tapped");
          // Add your navigation logic here
        },
      ),
      Setting(
        title: "Payment",
        icon: CupertinoIcons.money_dollar,
        color: Color(0xff212C42),
        onPressed: () {
          print("Payment tapped");
          // Add your navigation logic here
        },
      ),
    ];

    final List<Setting> settings3 = [
      Setting(
        title: "Add account",
        icon: CupertinoIcons.add,
        color: Color(0xff212C42),
        onPressed: () async{
          print("Log Out tapped");



        },
      ),

      Setting(
        title: "Log Out",
        icon: CupertinoIcons.lock,
        color: Colors.red,
        onPressed: () async{
          print("Log Out tapped");
          // Add your log out logic here
          // Naviguer vers l'écran de paramètres
          var pref = await SharedPreferences.getInstance();
          pref.setString("token", '');


          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => loginwidget()),
          );
        },
      ),
    ];

    final List<Setting> settings4 = [
      Setting(
        title: "account space ",
        icon: CupertinoIcons.person_fill,
        color: Color(0xff212C42),
        onPressed: () async{
          print("Log Out tapped");



        },
      ),

    ];

    return BackGround2(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15), // Optional: Adjusts padding inside the text field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15), // Custom border radius
                        ),
                        hintText: 'Enter a search term',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff212C42), // Couleur du titre
                    ),
                  ),
                  Column(
                    children: List.generate(
                      settings4.length,
                          (index) => SettingTile(setting: settings4[index]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Comment vous utilisez InstaZeal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff212C42), // Couleur du titre
                    ),
                  ),
                  Column(
                    children: List.generate(
                      settings.length,
                          (index) => SettingTile(setting: settings[index]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Votre application et vos contenus multimédias",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff212C42), // Couleur du titre
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: List.generate(
                      settings2.length,
                          (index) => SettingTile(setting: settings2[index]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff212C42), // Couleur du titre
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: List.generate(
                      settings3.length,
                          (index) => SettingTile(setting: settings3[index]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SupportCard()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Setting {
  final String title;
  final IconData icon;
  final Color color; // Nouvelle propriété pour la couleur
  final VoidCallback onPressed;

  Setting({
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
}

final List<Setting> settings = [
  Setting(
    title: "Personal Data",
    icon: CupertinoIcons.person_fill,
    color: Color(0xff212C42),
    onPressed: () {
      print("Personal Data tapped");
      // Add your navigation logic here
    },
  ),
  Setting(
    title: "Settings",
    icon: Icons.settings,
    color: Color(0xff212C42),
    onPressed: () {
      print("Settings tapped");
      // Add your navigation logic here
    },
  ),
  Setting(
    title: "E-Statements",
    icon: CupertinoIcons.doc_fill,
    color: Color(0xff212C42),
    onPressed: () {
      print("E-Statements tapped");
      // Add your navigation logic here
    },
  ),
  Setting(
    title: "Referral Code",
    icon: CupertinoIcons.heart_fill,
    color: Color(0xff212C42),
    onPressed: () {
      print("Referral Code tapped");
      // Add your navigation logic here
    },
  ),
];

class SettingTile extends StatelessWidget {
  final Setting setting;

  const SettingTile({
    super.key,
    required this.setting,
  });

  @override
  Widget build(BuildContext context) {
    const kprimaryColor = Color(0xff212C42);
    const ksecondryColor = Color(0xff9CA2FF);
    const ksecondryLightColor = Color(0xffEDEFFE);
    const klightContentColor = Color(0xffF1F2F7);

    const double kbigFontSize = 25;
    const double knormalFontSize = 18;
    const double ksmallFontSize = 15;

    return GestureDetector(
      onTap: setting.onPressed, // Use the onPressed callback
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: klightContentColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(setting.icon, color: kprimaryColor),
          ),
          const SizedBox(width: 10),
          Text(
            setting.title,
            style:  TextStyle(
              color: setting.color,
              fontSize: ksmallFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(
            CupertinoIcons.chevron_forward,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}

class SupportCard extends StatelessWidget {
  const SupportCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const kprimaryColor = Color(0xff212C42);
    const ksecondryColor = Color(0xff9CA2FF);
    const ksecondryLightColor = Color(0xffEDEFFE);
    const klightContentColor = Color(0xffF1F2F7);

    const double kbigFontSize = 25;
    const double knormalFontSize = 18;
    const double ksmallFontSize = 15;

    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: ksecondryLightColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            Icons.support_agent,
            size: 50,
            color: ksecondryColor,
          ),
          SizedBox(width: 10),
          Text(
            "Feel Free to Ask, We Are Ready to Help",
            style: TextStyle(
              fontSize: ksmallFontSize,
              color: ksecondryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
