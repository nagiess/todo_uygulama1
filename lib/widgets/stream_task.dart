import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_uygulama/data/firestore_data.dart';
import 'package:todo_uygulama/widgets/task_widgets.dart';

class StreamTask extends StatelessWidget {
  bool done;
  StreamTask(this.done, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreDatasource().stream(done),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final taskslist = FirestoreDatasource().getTasks(snapshot);
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final task = taskslist[index];
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    FirestoreDatasource().DeleteTask(task.id);
                  },
                  child: GorevWidget(task));
            },
            itemCount: taskslist.length,
          );
        });
  }
}
