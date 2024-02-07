import 'package:firebase_journal_app_with_bloc/bloc/app_blocs.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:firebase_journal_app_with_bloc/models/journal_model.dart';
import 'package:firebase_journal_app_with_bloc/views/journals_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchJournalDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: AppBloc().searchJournals(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final journal = snapshot.data!.docs;

          return ListView.builder(
            itemCount: journal.length,
            itemBuilder: (context, index) {
              final searchedJournal = Journal.fromSnapshot(journal[index]);

              return GestureDetector(
                onTap: () {
                  context.read<AppBloc>().add(
                        const AppEventExitSearch(),
                      );
                  context.read<AppBloc>().add(
                        AppEventIsInOverview(
                          journal: searchedJournal,
                        ),
                      );
                },
                child: JournalCard(journal: searchedJournal),
              );
            },
          );
        } else {
          return const Text('No journal found');
        }
      },
    );
  }
}
