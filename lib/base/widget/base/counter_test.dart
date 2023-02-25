import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/count_provider.dart';

class Counter extends StatelessWidget {
  Counter({Key? key}) : super(key: key);

  late CountProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CountProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('provider sample'),
      ),
      body: CountHome(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => _provider.increase(),
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => _provider.decrease(),
            icon: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CountHome extends StatelessWidget {
  const CountHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<CountProvider>(
        builder: (context, provider, child) => Text(
          Provider.of<CountProvider>(context).count.toString(),
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}