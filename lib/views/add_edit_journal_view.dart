import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_blocs.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/journal_model.dart';

class AddEditJournalView extends HookWidget {
  const AddEditJournalView({
    super.key,
    required this.isEdit,
    required this.journal,
  });
  final Journal journal;

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    print('string journal: ${journal.toString()}');
    final journalController = useTextEditingController(
      text: journal.text,
    );

    final dateTime = useState(
      DateTime.parse(journal.dateTime),
    );
    final imagesUrl = useState<List<dynamic>>(journal.images);
    final pageController = usePageController(viewportFraction: 0.7);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 1,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: GestureDetector(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: dateTime.value.add(
                const Duration(days: 1500),
              ),
            );
            if (selectedDate != null) {
              dateTime.value = selectedDate;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('d MMMM y').format(
                  dateTime.value,
                ),
                style: const TextStyle(color: Colors.greenAccent),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.greenAccent,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
            color: Colors.red,
          ),
        ],
        leading: ValueListenableBuilder(
            valueListenable: journalController,
            builder: (context, textController, child) {
              return ValueListenableBuilder(
                  valueListenable: imagesUrl,
                  builder: (context, images, child) {
                    return IconButton(
                      onPressed: () {
                        if (textController.text.isEmpty && images.isEmpty) {
                          context.read<AppBloc>().add(
                                const AppEventGoToHome(),
                              );
                          return;
                        }
                        final pickerColor = const Color(0xff443a49).toString();
                        final newJournal = Journal(
                          text: journalController.text.isEmpty
                              ? '(Empty text)'
                              : journalController.text,
                          dateTime: dateTime.value.toString(),
                          color: pickerColor,
                          documentId: journal.documentId,
                          userId: '',
                          images: imagesUrl.value,
                        );
                        if (isEdit) {
                          context.read<AppBloc>().add(
                                AppEventSavedJournal(
                                  journal: newJournal,
                                  isEdit: isEdit,
                                ),
                              );
                        } else {
                          context.read<AppBloc>().add(
                                AppEventSavedJournal(
                                  journal: newJournal,
                                  isEdit: isEdit,
                                ),
                              );
                        }
                      },
                      icon: textController.text.isEmpty && images.isEmpty
                          ? const Icon(
                              Icons.cancel,
                              color: Colors.greenAccent,
                            )
                          : const Icon(
                              Icons.check,
                              color: Colors.greenAccent,
                            ),
                    );
                  });
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: journalController,
                maxLines: null,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: imagesUrl.value.length,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: imagesUrl.value.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: imagesUrl.value[index],
                          progressIndicatorBuilder: ((context, url, progress) =>
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CircularProgressIndicator.adaptive(
                                  value: progress.progress,
                                ),
                              )),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            imagesUrl.value = [
                              ...imagesUrl.value
                                ..removeWhere(
                                  (imageUrl) =>
                                      imageUrl == imagesUrl.value[index],
                                ),
                            ];
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final cloudinary = CloudinaryPublic('dxjimzdsw', 'bixdlx92');
                final images = await ImagePicker().pickMultiImage();
                for (var image in images) {
                  final imageUpload = await cloudinary.uploadFile(
                    CloudinaryFile.fromFile(
                      image.path,
                      folder: '75RQvjabBXhQGNb8J4OfuXn5e8X2',
                    ),
                  );
                  print(imageUpload.secureUrl);
                  imagesUrl.value = [
                    ...imagesUrl.value..add(imageUpload.secureUrl),
                  ];
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload,
                    color: Colors.black,
                  ),
                  Text(
                    'Upload Image',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
