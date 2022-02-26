import 'package:daily_records_sandip/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      await Provider.of<DatabaseProvider>(context, listen: false).transactions();
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
    return Scaffold(
      extendBody: true,
      body: Consumer<DatabaseProvider>(
        builder: (_, provider, child) {
          final transactions = provider.transactionsList;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (__, index) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(transactions[index].worker.name),
                      ),
                    ),
                  childCount: transactions.length
                ),

              )
            ],
          );
        },
      ),
    );
  }
}
