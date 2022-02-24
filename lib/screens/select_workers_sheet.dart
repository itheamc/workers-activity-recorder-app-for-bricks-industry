import 'package:daily_records_sandip/models/worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';

class SelectWorkerSheet extends StatefulWidget {
  const SelectWorkerSheet({Key? key}) : super(key: key);

  @override
  _SelectWorkerSheetState createState() => _SelectWorkerSheetState();
}

class _SelectWorkerSheetState extends State<SelectWorkerSheet> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    const _radius = 24.0;
    final _workers = dummyWorkers;

    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: FractionallySizedBox(
          heightFactor: 0.7,
          widthFactor: 0.9,
          child: Card(
            color: Colors.pink.shade900,
            margin: const EdgeInsets.only(right: 10.0, top: 60.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_radius),
                topRight: Radius.circular(_radius / 6),
                bottomLeft: Radius.circular(_radius),
                bottomRight: Radius.circular(_radius),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 32.0, top: 7.5),
                              child: Text(
                                "कामदारहरु छान्नुहोस्।",
                                textAlign: TextAlign.center,
                                style: _theme.textTheme.headline6
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(_radius / 6),
                              bottomLeft: Radius.circular(_radius),
                            ),
                            child: Ink(
                              width: 32.0,
                              height: 32.0,
                              padding:
                                  const EdgeInsets.only(left: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                color: _theme.dividerColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(_radius / 6),
                                  bottomLeft: Radius.circular(_radius),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1.0,
                        color: Colors.white12,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 48.0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomScrollView(
                    controller: _controller,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) => _WorkerTile(
                            worker: _workers[index],
                            onPressed: () =>
                                Navigator.pop(context, _workers[index]),
                          ),
                          childCount: _workers.length,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20.0,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget for user tile
class _WorkerTile extends StatefulWidget {
  final Worker worker;
  final VoidCallback? onPressed;

  const _WorkerTile({Key? key, required this.worker, this.onPressed})
      : super(key: key);

  @override
  State<_WorkerTile> createState() => _WorkerTileState();
}

class _WorkerTileState extends State<_WorkerTile> {
  bool _init = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        _init = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _id = widget.worker.id;

    return ScaleTap(
      onPressed: widget.onPressed,
      scaleMinValue: 0.85,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 375),
        transform: _init
            ? Matrix4.translationValues(0, 0, 0)
            : _id! % 2 == 0
                ? Matrix4.translationValues(-100, -50, 0)
                : Matrix4.translationValues(100, 50, 0),
        child: Card(
          color: Colors.white24,
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Text(
              "${widget.worker.name}",
              style: _theme.textTheme.bodyText1?.copyWith(
                  color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
