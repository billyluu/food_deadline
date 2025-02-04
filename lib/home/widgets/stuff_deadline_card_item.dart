import 'package:flutter/material.dart';
import 'package:food_deadline/extension/datetime_extension.dart';

class StuffDeadlineCardItem extends StatefulWidget {
  const StuffDeadlineCardItem({
    required this.title,
    required this.deadline,
    this.color = Colors.white,
    this.disabled = false,
    this.onPressed,
    this.onDelete,
    super.key,
  });

  final String title;
  final String deadline;
  final bool disabled;
  final Color color;
  final Function()? onPressed;
  final Function()? onDelete;

  @override
  State<StuffDeadlineCardItem> createState() => _StuffDeadlineCardItemState();
}

class _StuffDeadlineCardItemState extends State<StuffDeadlineCardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double _maxLeft = -60.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = Tween(begin: 0.0, end: _maxLeft).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _moveLeft() {
    _controller.animateTo(1.0);
  }

  void _resetPosition() {
    _controller.animateTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: widget.disabled
                ? null
                : () {
                    widget.onDelete?.call();
                    _resetPosition();
                  },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  '刪除',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: widget.disabled
                ? null
                : (details) {
                    if (details.primaryDelta! < 0) {
                      _moveLeft();
                    } else if (details.primaryDelta! > 0) {
                      _resetPosition();
                    }
                  },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_animation.value, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: widget.color,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.deadline),
                            ).toYYYYMMDD(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
