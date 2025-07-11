import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_string.dart';
import 'package:food_deadline/core/extension/datetime_extension.dart';
import 'package:food_deadline/core/utils/date_time_helper.dart';
import 'package:food_deadline/shared/widgets/shared_common_text.dart';
import 'package:food_deadline/shared/widgets/shared_edit_icon_button.dart';

class ExpiredItemCard extends StatefulWidget {
  const ExpiredItemCard({
    required this.title,
    required this.expiryDate,
    this.disabled = false,
    this.onPressed,
    this.onDelete,
    super.key,
  });

  final String title;
  final String expiryDate;
  final bool disabled;
  final Function()? onPressed;
  final Function()? onDelete;

  @override
  State<ExpiredItemCard> createState() => _ExpiredItemCardState();
}

class _ExpiredItemCardState extends State<ExpiredItemCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey _cardKey = GlobalKey();
  var mainHeight = 0.0;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cardKey.currentContext != null) {
        final RenderBox box =
            _cardKey.currentContext!.findRenderObject() as RenderBox;
        setState(() {
          mainHeight = box.size.height;
        });
      }
    });
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
            onTap: () {
              widget.onDelete?.call();
              _resetPosition();
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                alignment: Alignment.centerRight,
                width: 150.0,
                height: mainHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(12.0),
                child: SharedCommonText(
                  text: AppString.commonDelete.getI18n(context),
                  textAlign: TextAlign.end,
                  style: CommonTextStyle.textStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
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
                    key: _cardKey,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SharedCommonText(
                            text: widget.title,
                            style: CommonTextStyle.textStyle(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SharedCommonText(
                            text: DateTimeHelper.formatMillisecondsToDate(
                              int.parse(widget.expiryDate),
                            ),
                            style: CommonTextStyle.textStyle(
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                        ),
                        SharedEditIconButton(
                          onPressed: () {},
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
