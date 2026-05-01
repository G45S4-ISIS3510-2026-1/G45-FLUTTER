import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g45_flutter/viewmodels/auth.dart';
import 'package:g45_flutter/viewmodels/review_viewmodel.dart';
import 'package:g45_flutter/widgets/tutor/tutor_review_card.dart';
import 'package:provider/provider.dart';
import 'package:g45_flutter/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  //-------------------------------------
  //  DRAFT REVIEW (CACHE)
  //-------------------------------------
  void _saveReviewDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("review_draft_${widget.tutorId}", _controller.text);
  }

  void _loadReviewDraft() async {
    final prefs = await SharedPreferences.getInstance();
    _controller.text = prefs.getString("review_draft_${widget.tutorId}") ?? "";
  }

  Future<void> _clearReviewDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("review_draft_${widget.tutorId}");
  }

  @override
  void initState() {
    super.initState();

    //----------------------------------
    //  INICIO MEDICIÓN TIEMPO
    //----------------------------------
    _startTime = DateTime.now();

    _loadReviewDraft();
    //----------------------------------
    // TAG DE SERVICIO (Crashlytics)
    //----------------------------------
    AnalyticsService.instance.setCurrentService("reviews");

    //----------------------------------
    // BQ IV — screen view
    //----------------------------------
    AnalyticsService.instance.logEvent("view_review", {
      "tutor_id": widget.tutorId,
    });
  }

  @override
  void dispose() {
    //----------------------------------
    // FIN MEDICIÓN TIEMPO
    //----------------------------------
    if (_startTime != null) {
      final seconds = DateTime.now().difference(_startTime!).inSeconds;

      AnalyticsService.instance.logEvent("time_spent_reviews", {
        "seconds": seconds,
        "tutor_id": widget.tutorId,
      });
    }

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewViewModel>();

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
            Text(
              "Reseñas",
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _openReviewModal(context),
              child: Text(
                "+ Nueva Reseña",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
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
          Text(
            "Aún no hay reseñas para este tutor.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

        //------------------------------------------
        // LISTA DE REVIEWS
        //------------------------------------------
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviewsToShow.length,
          itemBuilder: (_, i) => ReviewCard(review: reviewsToShow[i]),
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  //--------------------------------------------------
  // MODAL CREAR REVIEW
  //--------------------------------------------------
  void _openReviewModal(BuildContext context) {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A2A40),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        final vm = Provider.of<ReviewViewModel>(parentContext, listen: false);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //------------------------------------------
                      // TITLE
                      //------------------------------------------
                      Text(
                        "Nueva Reseña",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
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
                              setModalState(() {
                                rating = index + 1;
                              });
                            },
                            icon: Icon(
                              Icons.star,
                              color: index < rating
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                            ),
                          );
                        }),
                      ),

                      //------------------------------------------
                      // TEXT INPUT
                      //------------------------------------------
                      TextField(
                        controller: _controller,
                        onChanged: (value) => _saveReviewDraft(),
                        maxLines: 4,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: "Detalles de tu experiencia",
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHigh,
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
                          //----------------------------------
                          // CANCELAR
                          //----------------------------------
                          TextButton(
                            onPressed: () async {
                              await _clearReviewDraft();
                              _controller.clear();
                              rating = 0;

                              Navigator.pop(modalContext);
                            },
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),

                          //----------------------------------
                          // PUBLICAR
                          //----------------------------------
                          ElevatedButton(
                            onPressed: () async {
                              print("CLICK BOTON");

                              //----------------------------------
                              // VALIDACIÓN
                              //----------------------------------
                              if (rating == 0 ||
                                  _controller.text.trim().isEmpty) {
                                ScaffoldMessenger.of(modalContext).showSnackBar(
                                  const SnackBar(
                                    content: Text("Completa la reseña"),
                                  ),
                                );
                                return;
                              }

                              //----------------------------------
                              // FIREBASE USER
                              //----------------------------------
                              final firebaseUser =
                                  FirebaseAuth.instance.currentUser;

                              print("FIREBASE USER: $firebaseUser");

                              if (firebaseUser == null) {
                                print(" USER NULL");

                                ScaffoldMessenger.of(modalContext).showSnackBar(
                                  const SnackBar(
                                    content: Text("Usuario no autenticado"),
                                  ),
                                );
                                return;
                              }

                              //----------------------------------
                              // VIEWMODEL
                              //----------------------------------
                              final vm = parentContext.read<ReviewViewModel>();

                              //----------------------------------
                              // CREATE REVIEW
                              //----------------------------------
                              print("LLAMANDO CREATE REVIEW...");

                              final success = await vm.createReview(
                                authorId: firebaseUser.uid,
                                tutorId: widget.tutorId,
                                rating: rating,
                                details: _controller.text.trim(),
                              );

                              print("RESULTADO CREATE REVIEW: $success");

                              //----------------------------------
                              // SUCCESS
                              //----------------------------------
                              if (success) {
                                print(" REVIEW CREADA");
                                await AnalyticsService.instance
                                    .logEvent('review_submit', {
                                      'tutor_id': widget.tutorId,
                                      'review_length': _controller.text
                                          .trim()
                                          .length,
                                      'rating': rating,
                                    });

                                await _clearReviewDraft();
                                _controller.clear();

                                if (mounted) {
                                  setState(() {
                                    rating = 0;
                                  });
                                }

                                Navigator.pop(modalContext);
                              } else {
                                print(" ERROR DESDE VM: ${vm.errorMessage}");

                                FocusScope.of(modalContext).unfocus();

                                showDialog(
                                  context: parentContext,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    content: Text(
                                      vm.errorMessage ??
                                          "No se pudo enviar la reseña. Verifica tu conexión",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.tertiary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onTertiary,
                            ),

                            child: const Text("Publicar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
