import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_pix/widgets/delete_button.dart';
import 'package:swipe_pix/provider/card_provider.dart';
import 'package:provider/provider.dart';

Widget buildLogo(context) {
  final provider = Provider.of<CardProvider>(context);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 4),

          Text(
            'SwipePix',
            style: GoogleFonts.firaSans(
              textStyle: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      DeleteButton(count: provider.deleteNum),
    ],
  );
}