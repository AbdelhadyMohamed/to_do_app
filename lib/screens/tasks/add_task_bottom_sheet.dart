import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';
import 'package:to_do_app/shared/styles/colors.dart';

import '../../models/task_model.dart';
import '../../providers/tasks_provider.dart';

class TaskBottomSheet extends StatefulWidget {
  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  late DateTime selectedDate = DateTime.now();
  late TaskModel task;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: Container(
        height: 380,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Add new task",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                TextFormField(
                  validator: (value) {
                    if (titleController.text.isEmpty) {
                      return "Cannot leave title empty";
                    }
                    return null;
                  },
                  controller: titleController,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    hintText: "enter task title ",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  validator: (value) {
                    if (descriptionController.text.isEmpty) {
                      return "Cannot leave description empty";
                    }
                  },
                  controller: descriptionController,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    hintText: "enter task description ",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text("selected date",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black,
                    )),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () {
                    selectDate();
                  },
                  child: Text(provider.selectedDate.toString().substring(0, 10),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: blueColor,
                      )),
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      addTaskPressed();
                    },
                    child: const Text("Add task"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectDate() async {
    var provider = Provider.of<TasksProvider>(context, listen: false);

    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    selectedDate = chosenDate!;
    setState(() {});
  }

  addTaskPressed() {
    var provider = Provider.of<TasksProvider>(context, listen: false);

    if (formKey.currentState?.validate() ?? false) {
      TaskModel task = TaskModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          title: titleController.text,
          description: descriptionController.text,
          date: DateUtils.dateOnly(provider.selectedDate!)
              .millisecondsSinceEpoch);

      FirebaseManager.addTask(task);
      Navigator.pop(context);

      titleController.clear();
      descriptionController.clear();
      setState(() {});
    }
  }
}
