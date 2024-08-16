import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String text;
  final int quantity;
  final Color color;
  const ReportCard({super.key, required this.text, required this.quantity, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            //width: 50,
            //height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Padding(
             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ),
          SizedBox(width: 8,)
        ],
      ),
    );
  }
}