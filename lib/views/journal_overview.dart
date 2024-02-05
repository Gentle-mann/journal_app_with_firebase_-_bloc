import 'package:firebase_journal_app_with_bloc/bloc/app_blocs.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/journal_model.dart';

class JournalOverview extends StatelessWidget {
  const JournalOverview({super.key, required this.journal});
  final Journal journal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<AppBloc>().add(
                  const AppEventGoToHome(),
                );
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              context.read<AppBloc>().add(
                    AppEventIsInEditJournal(
                      journal: journal,
                    ),
                  );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_border),
          ),
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withAlpha(150),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BottomSheetText('Share as:'),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ShareBottomSheetAction(
                                      text: 'ZIP',
                                      iconData: Icons.folder_zip,
                                    ),
                                    ShareBottomSheetAction(
                                      text: 'Plain Text',
                                      iconData: Icons.menu,
                                    ),
                                    ShareBottomSheetAction(
                                      text: 'HTML',
                                      iconData: Icons.html,
                                    ),
                                    ShareBottomSheetAction(
                                      text: 'DOCX',
                                      iconData: Icons.document_scanner,
                                    ),
                                    ShareBottomSheetAction(
                                        text: 'PDF',
                                        iconData: Icons.picture_as_pdf),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat.d()
                        .format(
                          DateTime.parse(journal.dateTime),
                        )
                        .padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("d MMMM y").format(
                          DateTime.parse(journal.dateTime),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat("EEEE").add_jm().format(
                              DateTime.parse(journal.dateTime),
                            ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 2,
                child: Text(
                  journal.text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Image.network(src),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShareBottomSheetAction extends StatelessWidget {
  const ShareBottomSheetAction({
    super.key,
    required this.text,
    required this.iconData,
  });
  final String text;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BottomSheetIcon(
              iconData: iconData,
            ),
            const SizedBox(
              width: 20,
            ),
            BottomSheetText(text),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class BottomSheetIcon extends StatelessWidget {
  const BottomSheetIcon({
    super.key,
    required this.iconData,
  });
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: Colors.greenAccent,
      size: 30,
    );
  }
}

class BottomSheetText extends StatelessWidget {
  const BottomSheetText(
    this.text, {
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }
}
