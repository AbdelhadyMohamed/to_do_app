import 'package:flutter/material.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/screens/tasks/edit_task_bottom_sheet.dart';
import 'package:to_do_app/shared/network/firebase/firebase_manager.dart';
import 'package:to_do_app/shared/styles/colors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksItem extends StatelessWidget {
  TaskModel task;
  TasksItem(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent)),
      // color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.35,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  FirebaseManager.delTask(task.id);
                },
                backgroundColor: Colors.red,
                label: "delete",
                borderRadius: BorderRadius.circular(12),
                icon: Icons.delete,
              ),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.35,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  showEditTaskBottomSheet(context);
                },
                backgroundColor: Colors.blue,
                label: "edit",
                borderRadius: BorderRadius.circular(25),
                icon: Icons.edit,
              ),
            ],
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 15),
              Container(
                height: 80,
                width: 4,
                decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: blueColor)),
              ),
              const SizedBox(width: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: task.isDone ? Colors.green : blueColor,
                    ),
                  ),
                  Text(
                    task.description,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  task.isDone = true;
                  FirebaseManager.updateTask(task);
                },
                child: Container(
                  width: 75,
                  height: 75,
                  padding: const EdgeInsets.all(5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: task.isDone ? Colors.green : blueColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: task.isDone
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20, left: 14),
                          child: Text(
                            "Done!",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showEditTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: EditTaskBottomSheet(
                task: task,
              ));
        });
  }
}
