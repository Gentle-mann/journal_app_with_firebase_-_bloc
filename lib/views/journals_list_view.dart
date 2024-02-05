import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_blocs.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:firebase_journal_app_with_bloc/services/journal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/journal_model.dart';
import 'settings_view.dart';

class JournalsListView extends StatelessWidget {
  const JournalsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Your Journals',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) {
                    return const SettingsView();
                  }),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: JournalService().getJournals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              final journals = snapshot.data!.docs;
              journals.sort((a, b) {
                return DateTime.parse(b["dateTime"])
                    .compareTo(DateTime.parse(a["dateTime"]));
              });
              return ListView.builder(
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  final journal = journals[index];
                  return JournalCard(
                    journal: Journal.fromSnapshot(journal),
                    documentId: journal.id,
                  );
                },
              );
            }
          }),
      floatingActionButton: SizedBox(
        width: 110,
        child: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            context.read<AppBloc>().add(
                  const AppEventIsInAddJournal(),
                );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.add,
                color: Colors.black,
              ),
              Text(
                'Add Entry',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.journal,
    required this.documentId,
  });

  final Journal journal;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(documentId),
      onDismissed: (direction) {
        JournalService().deleteJournal(documentId: documentId);
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.delete,
            size: 30,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            DateFormat.yMMMMEEEEd().format(
              DateTime.parse(journal.dateTime),
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              context.read<AppBloc>().add(
                    AppEventIsInOverview(
                      journal: journal,
                    ),
                  );
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  radius: 30,
                  child: Text(
                    DateFormat.d().format(DateTime.parse(journal.dateTime)),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                title: Text(
                  journal.text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
