import 'package:daily_records_sandip/screens/add_worker_screen.dart';
import 'package:daily_records_sandip/utils/a_clippers.dart';
import 'package:daily_records_sandip/utils/route_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({Key? key}) : super(key: key);

  @override
  _WorkersScreenState createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
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

    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      floatingActionButton: SizedBox(
        height: 40.0,
        child: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.push(context, SlidePageRoute(AddWorkerScreen())),
          label: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("Add"),
          ),
        ),
      ),
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            backgroundColor: Colors.orange.shade200,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "कामदारहरु",
                style: _theme.textTheme.headline5?.copyWith(color: Colors.pink),
              ),
              titlePadding: const EdgeInsets.only(bottom: 10),
              centerTitle: true,
              background: Stack(
                children: [
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(color: _theme.dividerColor),
                  )
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20.0,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 2.5),
                      child: ScaleTap(
                        onPressed: () {},
                        scaleMinValue: 0.85,
                        child: Card(
                          elevation: 5,
                          shadowColor: _theme.dividerColor,
                          color: Colors.pink.shade400,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "कामदार - $index",
                              style: _theme.textTheme.headline6
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                childCount: 20),
          )
        ],
      ),
    );
  }
}
