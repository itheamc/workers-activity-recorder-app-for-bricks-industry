import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/utils/a_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';

import '../utils/a_clippers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.pink.shade400,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150.0,
                backgroundColor: Colors.pink.shade400,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "N. N. U",
                    style: _theme.textTheme.headline4?.copyWith(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  centerTitle: true,
                  background: Stack(
                    children: [
                      ClipPath(
                        clipper: WaveClipper(),
                        child: Container(color: _theme.dividerColor),
                      )
                    ],
                  ),
                  titlePadding: const EdgeInsets.only(bottom: 10.0),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 40.0,
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        child: SizedBox(
                          height: 150.0,
                          width: _size.height * 0.75,
                          child: ScaleTap(
                            onPressed: () =>
                                Navigator.pushNamed(context, MyRoute.workers),
                            scaleMinValue: 0.5,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    "निकासी इट्टा",
                                    style: _theme.textTheme.headline4
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        child: SizedBox(
                          height: 150.0,
                          width: _size.height * 0.75,
                          child: ScaleTap(
                            onPressed: () =>
                                Navigator.pushNamed(context, MyRoute.bharai),
                            scaleMinValue: 0.5,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    "भराई इट्टा",
                                    style: _theme.textTheme.headline4
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.75,
                        child: SizedBox(
                          height: 150.0,
                          child: ScaleTap(
                            onPressed: () =>
                                Navigator.pushNamed(context, MyRoute.pakki),
                            scaleMinValue: 0.5,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              color: Colors.deepOrange,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    "पक्की देली",
                                    style: _theme.textTheme.headline4
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                "Code with 💛 by @mit",
                style: _theme.textTheme.caption
                    ?.copyWith(color: Colors.white54, fontSize: 10.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
