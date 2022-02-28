import 'package:daily_records_sandip/providers/database_provider.dart';
import 'package:daily_records_sandip/screens/add_worker_screen.dart';
import 'package:daily_records_sandip/utils/a_clippers.dart';
import 'package:daily_records_sandip/utils/route_handler.dart';
import 'package:daily_records_sandip/widgets/a_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:provider/provider.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      DatabaseProvider p =
          Provider.of<DatabaseProvider>(context, listen: false);
      await p.workers();
    });
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
          onPressed: () => Navigator.push(
              context,
              SlidePageRoute(const AddWorkerScreen(),
                  begin: const Offset(-1, 0.5))),
          label: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("Add"),
          ),
          backgroundColor: Colors.pink.shade900,
          elevation: 20.0,
        ),
      ),
      extendBody: true,
      body: Consumer<DatabaseProvider>(builder: (_, provider, child) {
        final workers = provider.workersList;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150.0,
              backgroundColor: Colors.orange.shade200,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "कामदारहरु",
                  style:
                      _theme.textTheme.headline5?.copyWith(color: Colors.pink),
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
                          onLongPress: () async {
                            final res = await ADialog.showDialog(context,
                                title: "हटाउनुहोस !!");
                            if (res != null && res) {
                              final msg =
                                  await provider.deleteWorker(workers[index]);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    const Text('कामदारलाई सफलतापुर्बक हटाइयो।'),
                                duration: const Duration(seconds: 4),
                                action: SnackBarAction(
                                    label: "फेरी ल्याउनुहोस।",
                                    onPressed: provider.handleWorkerUndo),
                              ));
                            }
                          },
                          scaleMinValue: 0.85,
                          child: Card(
                            elevation: 5,
                            shadowColor: _theme.dividerColor,
                            color: Colors.pink.shade400,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                workers[index].name,
                                style: _theme.textTheme.headline6
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                  childCount: workers.length),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 40.0,
              ),
            )
          ],
        );
      }),
    );
  }
}