import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget buildTaskItem(Map record, BuildContext context){
  return Dismissible(
    key: Key(record['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),

            ),
            height: 80.0,
            width: 80.0,
            child: Center(
              child: Text(
                "${record['priority']}",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          const SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${record['title']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 5.0,),
                Row(
                  children: [
                    Text(
                        "${record['time']}",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),

                    ),
                    const SizedBox(width: 5.0,),
                    Text(
                      "${record['date']}",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                        fontSize: 15.0,
                      ),

                    ),

                  ],
                ),
              ],
            ),
          ),

          IconButton(
              onPressed: (){
                AppCubit.get(context).updateDB(status: "done", id: record['id']);
              },
              icon: const Icon(Icons.check_box),
            color: Colors.green,
          ),
          IconButton(
              onPressed: (){
                AppCubit.get(context).updateDB(status: "archived", id: record['id']);

              },
              icon: const Icon(Icons.archive),
            color: Colors.black54,
          )
        ],
      ),
    ),
    onDismissed: (direction){
      AppCubit.get(context).deleteDB(id: record['id']);

    },
  );
}


