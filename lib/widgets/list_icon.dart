import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListIcon extends StatelessWidget {
  const ListIcon({Key? key, required this.companyName}) : super(key: key);

  final String companyName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          companyName[0],
          style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
