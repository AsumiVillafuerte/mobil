import 'package:flutter/material.dart';
import '../models/room.dart';

class CustomSlidableRoomCard extends StatefulWidget {
  final Room room;
  final VoidCallback onUpdateStatus;

  const CustomSlidableRoomCard({
    super.key,
    required this.room,
    required this.onUpdateStatus,
  });

  @override
  State<CustomSlidableRoomCard> createState() => _CustomSlidableRoomCardState();
}

class _CustomSlidableRoomCardState extends State<CustomSlidableRoomCard> {
  double _dragPosition = 0;

  double get _buttonsWidth {
    return widget.room.status == 'Activo' ? 180 : 90;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragPosition += details.delta.dx;
          _dragPosition = _dragPosition.clamp(-_buttonsWidth, 0.0);
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() {
          if (_dragPosition.abs() > _buttonsWidth / 2) {
            _dragPosition = -_buttonsWidth;
          } else {
            _dragPosition = 0;
          }
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: widget.room.status == 'Activo'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFF4CAF50),
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _dragPosition = 0;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFF44336),
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                widget.onUpdateStatus();
                                setState(() {
                                  _dragPosition = 0;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF4CAF50),
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () {
                            widget.onUpdateStatus();
                            setState(() {
                              _dragPosition = 0;
                            });
                          },
                        ),
                      ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_dragPosition, 0, 0),
            child: Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.bed_outlined, color: Colors.blue, size: 40),
                title: Text(widget.room.roomNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.room.description),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.room.statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.room.status,
                    style: TextStyle(color: widget.room.statusTextColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
