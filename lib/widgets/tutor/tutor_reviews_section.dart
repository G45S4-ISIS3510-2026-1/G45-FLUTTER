import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/review_viewmodel.dart';
import 'package:g45_flutter/widgets/tutor/tutor_review_card.dart';
import 'package:provider/provider.dart';
import 'package:g45_flutter/models/review.dart';

import 'package:g45_flutter/services/analytics_service.dart';

class TutorReviewsSection extends StatefulWidget {
  final String tutorId;

  const TutorReviewsSection({super.key, required this.tutorId});

  @override
  State<TutorReviewsSection> createState() => _TutorReviewsSectionState();
}

class _TutorReviewsSectionState extends State<TutorReviewsSection> {
  final TextEditingController _controller = TextEditingController();
  int rating = 0;
  bool showAll = false;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();

    //----------------------------------
    // 🔥 INICIO MEDICIÓN TIEMPO
    //----------------------------------
    _startTime = DateTime.now();

    //----------------------------------
    // TAG DE SERVICIO (Crashlytics)
    //----------------------------------
    AnalyticsService.instance.setCurrentService("reviews");

    //----------------------------------
    // cargar reviews
    //----------------------------------
    Future.microtask(() {
      Provider.of<ReviewViewModel>(
        context,
        listen: false,
      ).loadReviewsByTutor(widget.tutorId);
    });

    //----------------------------------
    // BQ IV — screen view
    //----------------------------------
    AnalyticsService.instance.logEvent("screen_view", {
      "screen_name": "TutorProfileReview",
      "screen_class": "TutorProfile",
    });
  }

  @override
  void dispose() {
    //----------------------------------
    // 🔥 FIN MEDICIÓN TIEMPO
    //----------------------------------
    if (_startTime != null) {
      final seconds = DateTime.now().difference(_startTime!).inSeconds;

      AnalyticsService.instance.logEvent("time_spent_reviews", {
        "seconds": seconds,
        "tutor_id": widget.tutorId,
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReviewViewModel>(context);

    final reviewsToShow = showAll ? vm.reviews : vm.reviews.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------------------------
        // HEADER
        //------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Reseñas",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _openReviewModal(context),
              child: const Text(
                "+ Nueva Reseña",
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ],
        ),

        //------------------------------------------
        // LOADING
        //------------------------------------------
        if (vm.isLoading) const Center(child: CircularProgressIndicator()),

        //------------------------------------------
        // EMPTY STATE
        //------------------------------------------
        if (!vm.isLoading && vm.reviews.isEmpty)
          const Text(
            "Aún no hay reseñas para este tutor.",
            style: TextStyle(color: Colors.white54),
          ),

        //------------------------------------------
        // LISTA DE REVIEWS
        //------------------------------------------
        Column(
          children: reviewsToShow.map((review) {
            return ReviewCard(review: review);
          }).toList(),
        ),

        //------------------------------------------
        // VER MÁS
        //------------------------------------------
        if (vm.reviews.length > 2)
          TextButton(
            onPressed: () {
              setState(() {
                showAll = !showAll;
              });
            },
            child: Text(
              showAll ? "Ver menos" : "Ver todas (${vm.reviews.length})",
              style: const TextStyle(color: Colors.yellow),
            ),
          ),
      ],
    );
  }

  //--------------------------------------------------
  // MODAL CREAR REVIEW
  //--------------------------------------------------
  void _openReviewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A2A40),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Consumer<ReviewViewModel>(
            builder: (context, vm, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------------------
                  // TITLE
                  //------------------------------------------
                  const Text(
                    "Nueva Reseña",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  //------------------------------------------
                  // RATING
                  //------------------------------------------
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: index < rating
                              ? Colors.yellow
                              : Colors.white38,
                        ),
                      );
                    }),
                  ),

                  //------------------------------------------
                  // TEXT INPUT
                  //------------------------------------------
                  TextField(
                    controller: _controller,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Detalles de tu experiencia",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  //------------------------------------------
                  // BUTTONS
                  //------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.yellow),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                final success = await vm.createReview(
                                  tutorId: widget.tutorId,
                                  rating: rating,
                                  details: _controller.text,
                                );

                                if (success) {
                                  //----------------------------------
                                  // BQ IX ANALYTICS
                                  //----------------------------------
                                  AnalyticsService.instance.logEvent(
                                    "review_submit",
                                    {
                                      "review_length": _controller.text.length,
                                      "rating": rating,
                                      "tutor_id": widget.tutorId,
                                    },
                                  );

                                  Navigator.pop(context);
                                  _controller.clear();
                                  rating = 0;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.errorMessage ?? "Error"),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                        ),
                        child: vm.isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Publicar"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
