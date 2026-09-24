import 'package:flutter/material.dart';
import 'package:easy_life_club/providers/providers.dart';
import 'package:easy_life_club/theme/app_theme.dart';

class EventDialog extends StatefulWidget {
  final int currentIndex;
  final VoidCallback onNext;

  const EventDialog({
    super.key,
    required this.currentIndex,
    required this.onNext,
  });

  @override
  State<EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    if (events == null || events.isEmpty) {
      return Container(); // Return an empty container if there are no events
    }
    final event = events[widget.currentIndex];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),  
      ),
      backgroundColor: Colors.white.withOpacity(0.4),
      child: 
        ClipRRect(
          borderRadius: BorderRadius.circular(20),  
          child: 
        Container(
          padding: const EdgeInsets.fromLTRB(16,8,16,16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),  
            boxShadow: const [
              BoxShadow(
                color: AppTheme.primary,
                blurRadius: 3.75,
                offset: Offset(0, 5),
              ),
            ],
          ),  
          child: Column(
            mainAxisSize: MainAxisSize.min,          
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onNext();
                  },
                  child: const Icon(Icons.close),
                ),
              ),
              const SizedBox(height: 5,),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: 
                Image.network(
                  event.image,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                    width: 60,
                    height: 60,
                    padding: const  EdgeInsets.all(8),
                    child: const CircularProgressIndicator(color: Colors.white),
                  );
                },
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                event.title,
                style: AppTheme.darkTheme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5,),
              Text(
                event.description,
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
    );
  }
}
