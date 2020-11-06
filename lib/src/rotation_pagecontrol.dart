part of idkit_rotation;

class IDKitPageControl extends StatefulWidget {
  const IDKitPageControl({
    Key key,
    this.count,
    this.selectIndex,
    this.pageSize,
    this.color,
    this.activiteColor,
    this.shape,
    this.interval,
  }) : super(key: key);
  final int count;
  final int selectIndex;
  final double pageSize;
  final Color color;
  final Color activiteColor;
  final BoxShape shape;
  final double interval;

  @override
  IDKitPageControlState createState() => IDKitPageControlState();
}

class IDKitPageControlState extends State<IDKitPageControl> {
  GlobalKey<_PageItemState> _globalKey;
  List<Widget> _list;
  List<GlobalKey<_PageItemState>> _globalKeyList;
  int _selectIndex;
  double _width;
  double _interval;
  double _pageSize;
  @override
  void initState() {
    super.initState();
    _selectIndex = widget.selectIndex ?? 0;
    _pageSize = widget.pageSize ?? 8;
    _interval = widget.interval ?? 5;
    _width = _pageSize * widget.count + _interval * (widget.count - 1);
    _globalKeyList = List.generate(widget.count, (index) => GlobalKey());
    _list = List.generate(
        widget.count,
        (index) => PageItem(
              key: _globalKeyList[index],
              state: index == _selectIndex,
              color: widget.color,
              activeColor: widget.activiteColor,
              shape: widget.shape,
              size: _pageSize,
            ));
    _globalKey = _globalKeyList[_selectIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _list,
      ),
    );
  }

  // 选择那个
  void selectItem(int index) {
    _globalKey.currentState.unSelectState();
    _globalKey = _globalKeyList[index];
    _globalKey.currentState.selectState();
  }
}

class PageItem extends StatefulWidget {
  PageItem({
    Key key,
    this.state,
    this.color,
    this.activeColor,
    this.shape,
    this.size,
  }) : super(key: key);
  final bool state;
  final Color color;
  final double size;
  final Color activeColor;
  final BoxShape shape;

  @override
  _PageItemState createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> {
  Color _color;
  BoxShape _boxShape;
  double _size;
  Color _defColor;
  Color _defActiviteColor;
  @override
  void initState() {
    super.initState();
    _defColor = widget.color ?? Colors.white;
    _defActiviteColor = widget.activeColor ?? Colors.black;
    _color = widget.state ? _defActiviteColor : _defColor;
    _boxShape = widget.shape ?? BoxShape.circle;
    _size = widget.size ?? 8;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: _boxShape,
        color: _color,
      ),
    );
  }

  void selectState() {
    setState(() {
      _color = _defActiviteColor;
    });
  }

  void unSelectState() {
    setState(() {
      _color = _defColor;
    });
  }
}
