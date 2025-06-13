import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/model/reminder_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleCard extends StatefulWidget {
  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  List<ReminderEvent> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventData = prefs.getStringList('reminder_events') ?? [];
    setState(() {
      events = eventData
          .map((e) => ReminderEvent.fromMap(Map<String, dynamic>.from(jsonDecode(e))))
          .toList();
    });
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventData = events.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('reminder_events', eventData);
  }

  void _addEvent(ReminderEvent event) {
    setState(() {
      events.add(event);
    });
    _saveEvents();
  }

  void _deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
    _saveEvents();
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    Color selectedColor = Colors.teal;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              title: const Text(
                'Add Reminder',
                style: TextStyle(
                  color: AppColors.brandColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(labelText: 'Time'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<Color>(
                    value: selectedColor,
                    items: [
                      Colors.teal,
                      Colors.orange,
                      Colors.blue,
                      Colors.red,
                    ]
                        .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(
                        _getColorName(c),
                        style: TextStyle(color: c),
                      ),
                    ))
                        .toList(),
                    onChanged: (color) {
                      if (color != null) {
                        setState(() {
                          selectedColor = color;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        timeController.text.isNotEmpty) {
                      _addEvent(ReminderEvent(
                        title: titleController.text,
                        time: timeController.text,
                        colorValue: selectedColor.value,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: AppColors.brandColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "What's up Today?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showAddEventDialog,
                child: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.brandColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...events.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(width: 4, height: 40, color: Color(e.colorValue)),
              title: Text(e.title),
              subtitle: Text(e.time),
              trailing: IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () => _deleteEvent(i),
              ),
            );
          }),
        ],
      ),
    );
  }
}

String _getColorName(Color color) {
  if (color == Colors.teal) return 'Teal';
  if (color == Colors.orange) return 'Orange';
  if (color == Colors.blue) return 'Blue';
  if (color == Colors.red) return 'Red';
  return 'Color';
}
