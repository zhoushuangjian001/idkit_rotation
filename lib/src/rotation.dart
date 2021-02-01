part of idkit_rotation;

class IDKitRotation extends StatefulWidget {
  const IDKitRotation({
    Key key,
    this.future,
    @required this.buildItem,
    @required this.height,
    this.rotationDirection,
    this.placeholderChild,
    this.animationTime,
    this.rotationCurve,
    this.width,
    this.didSelectItem,
    this.pageControlState,
    this.pageControlAligment,
    this.pageControlEdgeInsets,
    this.pageControlSize,
    this.pageControlActiveSize,
    this.pageControlColor,
    this.pageControlActiveColor,
    this.pageControlShape,
    this.rateTime,
  }) : super(key: key);
  final double width;
  final double height;
  final int animationTime;
  final Curve rotationCurve;
  final bool pageControlState;
  final Axis rotationDirection;
  final Widget placeholderChild;
  final Size pageControlSize;
  final Size pageControlActiveSize;
  final Color pageControlColor;
  final Color pageControlActiveColor;
  final BoxShape pageControlShape;
  final Future<List<dynamic>> future;
  final PageControlAlignment pageControlAligment;
  final PageControlEdgeInsets pageControlEdgeInsets;
  final Function(dynamic data, int index) didSelectItem;
  final Function(BuildContext context, int index, dynamic data) buildItem;
  final int rateTime;
  @override
  _IDKitRotationState createState() => _IDKitRotationState();
}

class _IDKitRotationState extends State<IDKitRotation> {
  ScrollController _scrollController;
  Widget _placeholderChild;
  Axis _axis;
  MediaQueryData _mediaQueryData;
  int _animationTime;
  Curve _curve;
  double _width;
  Timer _timer;
  int _total;
  double _baseOffset;
  GlobalKey<IDKitPageControlState> _globalKey = GlobalKey();
  bool _pageControlState;
  PageControlEdgeInsets _pageControlEdgeInsets;
  int _rateTime;
  @override
  void initState() {
    super.initState();
    _mediaQueryData = MediaQueryData.fromWindow(window);
    _axis = widget.rotationDirection ?? Axis.horizontal;
    _width = widget.width ?? _mediaQueryData.size.width;
    _placeholderChild = widget.placeholderChild ?? Container();
    _animationTime = widget.animationTime ?? 500;
    _curve = widget.rotationCurve ?? Curves.ease;
    _baseOffset = _axis == Axis.horizontal
        ? _width.roundToDouble()
        : widget.height.roundToDouble();
    _scrollController = ScrollController(initialScrollOffset: _baseOffset);
    _total = 0;
    _pageControlState = widget.pageControlState ?? true;
    _pageControlEdgeInsets =
        widget.pageControlEdgeInsets ?? PageControlEdgeInsets.only();
    _rateTime = widget.rateTime ?? 3;
  }

  // 数据处理
  List<dynamic> _dataProcessing(dynamic data) {
    var _dataList = [];
    if (data is List) {
      _dataList = data;
    }
    var _resultList = List.from(_dataList);
    _resultList.insert(0, _dataList.last);
    _resultList.add(_dataList.first);
    return _resultList;
  }

  // 计时器的创建
  Timer _timerBuild() {
    return Timer.periodic(Duration(seconds: _rateTime), (timer) {
      if (_scrollController.hasClients) {
        final _scrollOffset = _scrollController.position.pixels;
        var _index = _scrollOffset ~/ _baseOffset;
        final _offset = _scrollOffset + _baseOffset;
        _scrollController
            .animateTo(_offset,
                duration: Duration(milliseconds: _animationTime), curve: _curve)
            .whenComplete(() {
          // 只会向前走
          if (_total - 2 == _index) _scrollController.jumpTo(_baseOffset);
        });
        // 控制下方小白点
        if (_globalKey.currentState != null)
          _globalKey.currentState.selectItem(_index == _total - 2 ? 0 : _index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) return _placeholderChild;
            // 数据处理
            final _list = _dataProcessing(snapshot.data);
            // 记录总数量
            _total = _list.length;
            // 计时器创建
            _timer = _timerBuild();
            if (_pageControlState) {
              return Stack(
                children: [
                  _rotationWidget(_list),
                  _rotationPageControl(_list),
                ],
              );
            } else {
              return _rotationWidget(_list);
            }
          } else {
            return _placeholderChild;
          }
        },
      ),
    );
  }

  // 轮播的主 Widget
  Widget _rotationWidget(List list) {
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: _axis,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return GestureDetectorItem(
            child: SizedBox(
              height: widget.height,
              width: _width,
              child: widget.buildItem(context, index, list[index]),
            ),
            scrollController: _scrollController,
            tag: index,
            offset: _baseOffset,
            total: _total,
            animationTime: _animationTime,
            animationCurve: _curve,
            downTap: () {
              if (_timer != null) {
                _timer.cancel();
                _timer = null;
              }
            },
            endTap: () {
              if (_timer == null) _timer = _timerBuild();
            },
            onTap: () {
              if (widget.didSelectItem != null)
                widget.didSelectItem(list[index], index - 1);
            },
            pageControl: _globalKey,
          );
        },
        itemCount: _total,
      ),
    );
  }

  // 小白点 Widget
  Widget _rotationPageControl(List list) {
    return Positioned(
      bottom: _pageControlEdgeInsets.bottom,
      right: _pageControlEdgeInsets.right,
      left: _pageControlEdgeInsets.left,
      top: _pageControlEdgeInsets.top,
      child: Container(
        alignment: widget.pageControlAligment ?? Alignment.center,
        child: IDKitPageControl(
          key: _globalKey,
          count: list.length - 2,
          shape: widget.pageControlShape,
          activiteColor: widget.pageControlActiveColor ?? Colors.white,
          color: widget.pageControlColor ?? Colors.black,
          activitePageSize: widget.pageControlActiveSize ?? Size(8, 8),
          pageSize: widget.pageControlSize ?? Size(8, 8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}

class PageControlAlignment {
  static Alignment left = Alignment.bottomLeft;
  static Alignment center = Alignment.bottomCenter;
  static Alignment right = Alignment.bottomRight;
}

class PageControlEdgeInsets {
  double left;
  double right;
  double top;
  double bottom;
  PageControlEdgeInsets({
    this.top,
    this.left,
    this.bottom,
    this.right,
  });
  static PageControlEdgeInsets only({
    double top,
    double left,
    double bottom,
    double right,
  }) {
    return PageControlEdgeInsets(
        top: top, left: left ?? 10, right: right ?? 10, bottom: bottom ?? 10);
  }
}
