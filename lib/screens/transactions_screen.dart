import 'package:daily_records_sandip/models/transaction.dart';
import 'package:daily_records_sandip/providers/database_provider.dart';
import 'package:daily_records_sandip/screens/transaction_details_screen.dart';
import 'package:daily_records_sandip/utils/extension_fn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

import '../utils/a_clippers.dart';
import '../utils/route_handler.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await Provider.of<DatabaseProvider>(context, listen: false)
          .transactions();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.orange.shade200,
      body: Consumer<DatabaseProvider>(
        builder: (_, provider, child) {
          final transactions = provider.transactionsList.toATransactions();
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 150.0,
                backgroundColor: Colors.orange.shade200,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "दैनिक विवरणहरु",
                    style: _theme.textTheme.headline5
                        ?.copyWith(color: Colors.pink),
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
              ...List.generate(
                transactions.length,
                (index) => _StickyHeaderSliverList(
                  transactions: transactions[index].transactions,
                  provider: provider,
                  label: transactions[index].label,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _StickyHeaderSliverList extends StatelessWidget {
  const _StickyHeaderSliverList(
      {Key? key,
      required this.transactions,
      required this.provider,
      this.label})
      : super(key: key);
  final List<ATransaction> transactions;
  final DatabaseProvider provider;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return SliverStickyHeader(
      overlapsContent: true,
      header: _SideHeader(label: label),
      sliver: SliverPadding(
        padding: const EdgeInsets.only(left: 40.0, bottom: 40.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
              (__, index) => ScaleTap(
                    onPressed: () {
                      provider.handleSelect(transactions[index]);
                      Navigator.push(
                          context,
                          SlidePageRoute(
                              const TransactionDetailScreen(),
                              begin: const Offset(-1, 0.5)));
                    },
                    scaleMinValue: 0.85,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                transactions[index].worker.name,
                                style: _theme.textTheme.bodyText1,
                              ),
                            ),
                            Text(
                              "${transactions[index].records.total()}",
                              style: _theme.textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              childCount: transactions.length),
        ),
      ),
    );
  }
}

class _SideHeader extends StatelessWidget {
  const _SideHeader({
    Key? key,
    this.label,
  }) : super(key: key);

  final String? label;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 45.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RotatedBox(
          quarterTurns: 3,
          child: InkWell(
            onTap: () {},
            child: Ink(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              width: 100.0,
              color: Colors.black87,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Text(
                  "$label".toUpperCase(),
                  style: _theme.textTheme.caption?.copyWith(
                      color: Colors.white70, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
