import 'package:flutter/material.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/history/history.viewmodel.dart';

class HistoryView extends ViewBase<HistoryViewModel> {
  HistoryView(HistoryViewModel viewModel)
      : super(viewModel, const Key("HistoryView"));

  Future<void> goDetails(BuildContext context) async {
    viewModel.coordinator.move(ViewIdentifiers.historyDetails, context);
  }

  @override
  Widget buildWithViewModel(
      BuildContext context, HistoryViewModel viewModel, ViewSize viewSize) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Payment History"),
      ),
      body: viewModel.hasHistory()
          ? buildHistory(context, viewModel, viewSize)
          : buildNoHistory(context, viewModel, viewSize),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.buildHistory();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNoHistory(
      BuildContext context, HistoryViewModel viewModel, ViewSize viewSize) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: viewModel.updateStringValue,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D4AFF), elevation: 0),
                child: Text(
                  "No history".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                viewModel.mnemonicString,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ]));
  }

  Widget buildHistory(
      BuildContext context, HistoryViewModel viewModel, ViewSize viewSize) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
            ),
        itemCount: viewModel.history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: FittedBox(
              child: Text(
                viewModel.history[index].txid,
                style: const TextStyle(color: Colors.blue),
                textAlign: TextAlign.left,
                maxLines: 3,
                softWrap: true,
              ),
            ),
            subtitle: Text(
                "Send: ${viewModel.history[index].sent.toString()} - Receive: ${viewModel.history[index].received.toString()} - Fee: ${viewModel.history[index].fee.toString()} Time: ${viewModel.history[index].confirmationTime?.timestamp.toString()} "),
            onTap: () {
              viewModel.updateSelected(index);
              goDetails(context);
            },
          );
        });
  }
}
