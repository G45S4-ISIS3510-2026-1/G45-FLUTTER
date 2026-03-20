import 'package:flutter/material.dart';
import 'package:g45_flutter/models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    //------------------------------------------
    //Container Principal y colores
    //------------------------------------------
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1A2A40),
        borderRadius: BorderRadius.circular(16),
      ),
      // Filla con Imagen y columna de datos
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: review.authorImage != null
                ? NetworkImage(review.authorImage!)
                : null,
          ),
          SizedBox(width: 10),

          Expanded(
            //Columna  
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FILA SUPERIOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.authorName,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text("⭐ ${review.rating}"),
                  ],
                ),

                SizedBox(height: 4),
                //FILA DE LA MITAD
                Text(
                  review.details,
                  style: TextStyle(color: Colors.white70),
                ),

                SizedBox(height: 4),
                //FILA DE ABAJO
                Text(
                  review.createdAt.toString().split(" ")[0],
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}