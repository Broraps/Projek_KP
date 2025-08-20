import 'package:flutter/material.dart';
import 'package:youtube/styles/style.dart';
import 'package:youtube/widgets/site_logo.dart';
import '../../constants/colors.dart';
import '../../constants/nav_items.dart';

class HeaderDekstop extends StatelessWidget {
  const HeaderDekstop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin:const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.maxFinite,
      decoration: kHeaderDecoration,
      child: Row(
        children: [
          SiteLogo(onTap: (){
            if (ModalRoute.of(context)?.settings.name != '/') {
              Navigator.pushNamed(context, '/');
            }
          },
          ),
          const Spacer(),
          for(int i=0; i < navTitles.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                onPressed: (){
                  if (navTitles[i] == "Home") {
                    Navigator.pushNamed(context, '/');
                  } else if (navTitles[i] == "Tentang Kami") {
                    Navigator.pushNamed(context, '/about');
                  } else if (navTitles[i] == "Pesan") {
                    Navigator.pushNamed(context, '/order');
                  }
                },
                child: Text(navTitles[i],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CustomColor.whitePrimary,)),
              ),
            ),
        ],
      ),
    );
  }
}
