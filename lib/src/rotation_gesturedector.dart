part of idkit_rotation;

class GestureDetectorItem extends StatelessWidget {
  const GestureDetectorItem({
    this.child,
    this.scrollController,
    this.offset,
    this.tag,
    this.total,
    this.animationTime,
    this.animationCurve,
    this.downTap,
    this.endTap,
    this.onTap,
    this.pageControl,
  });
  final int tag;
  final int total;
  final Widget child;
  final double offset;
  final Function onTap;
  final Function endTap;
  final Function downTap;
  final int animationTime;
  final Curve animationCurve;
  final ScrollController scrollController;
  final GlobalKey<IDKitPageControlState> pageControl;

  @override
  Widget build(BuildContext context) {
    /// -1: right || 1: left || 0: situ
    var isMark = 0;
    return GestureDetector(
      child: child,
      onTap: () {
        if (onTap != null) onTap();
      },
      onHorizontalDragDown: (details) {
        // 停止定时器
        downTap();
      },
      onHorizontalDragUpdate: (details) {
        var dx = details.delta.dx;
        var dy = details.delta.dy;
        if (dx > 0 || dy > 0) isMark = -1;
        if (dx < 0 || dy < 0) isMark = 1;
      },
      onHorizontalDragEnd: (details) {
        _manualEventHandling(isMark);
      },
      onVerticalDragUpdate: (details) {
        var dx = details.delta.dx;
        var dy = details.delta.dy;
        if (dx > 0 || dy > 0) isMark = -1;
        if (dx < 0 || dy < 0) isMark = 1;
      },
      onVerticalDragEnd: (details) {
        _manualEventHandling(isMark);
      },
      onHorizontalDragCancel: () {
        if (endTap != null) endTap();
      },
    );
  }

  // 手动小白点的控制
  void _pageControlSelectHandle() {
    if (pageControl.currentState != null) {
      final _index = scrollController.position.pixels ~/ offset;
      if (_index == total - 1) {
        pageControl.currentState.selectItem(total - 2);
      } else if (_index == 1) {
        pageControl.currentState.selectItem(0);
      } else {
        pageControl.currentState.selectItem(_index - 1);
      }
    }
  }

  // 手动轮播处理
  void _manualEventHandling(int isMark) {
    final _curOffset = scrollController.position.pixels;
    var _offset = _curOffset + offset * isMark;
    scrollController
        .animateTo(_offset,
            duration: Duration(milliseconds: animationTime),
            curve: animationCurve)
        .whenComplete(() {
      if (1 == tag && isMark == -1) {
        _offset = (total - 2) * offset;
        scrollController.jumpTo(_offset);
      }
      if (total - 2 == tag && isMark == 1) {
        _offset = offset;
        scrollController.jumpTo(_offset);
      }
      Future.delayed(Duration(seconds: 3), endTap);
      _pageControlSelectHandle();
    });
  }
}
