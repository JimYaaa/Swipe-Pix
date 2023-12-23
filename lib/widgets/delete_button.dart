import 'package:flutter/material.dart';
import 'package:swipe_pix/provider/card_provider.dart';
import 'package:provider/provider.dart';

final deleteButtonKey = GlobalKey();

class DeleteButton extends StatefulWidget {
  final int count;

  const DeleteButton({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  DeleteButtonState createState() => DeleteButtonState();
}

class DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.count.toString(),
          style: const TextStyle(
            fontSize:  20,
            fontWeight: FontWeight.bold,
            color: Colors.black
          )
        ),

        const SizedBox(width: 5),

        SizedBox(
          width: 30,
          height: 30,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: IconButton(
              key: deleteButtonKey,
              padding: const EdgeInsets.all(0.0),
              icon: const Icon(
                Icons.delete_sharp,
                color: Colors.white,
                size: 20,
              ),
              tooltip: 'Delete Photo',
              onPressed: () {
                provider.deletePhoto();
              },
            ),
          ),
        )
      ],
    );
  }
}