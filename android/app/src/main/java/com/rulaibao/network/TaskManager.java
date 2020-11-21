package com.rulaibao.network;

import java.util.LinkedList;
import java.util.List;

public class TaskManager {
    private List<MyAsyncTask> taskList = new LinkedList<MyAsyncTask>();

    public TaskManager() {

    }

    public synchronized void addTask(MyAsyncTask task) {
        if (task != null) {
            taskList.add(task);
            task.parallelExecute();
        }
    }

    public synchronized void removeTask(MyAsyncTask task) {
        if (task != null) {
            taskList.remove(task);
        }
    }

    public synchronized void cancelAllTask() {
        for (int i = taskList.size() - 1; i >= 0; i--) {
            MyAsyncTask task = taskList.remove(i);
            task.cancel(true);
        }
    }

//    public synchronized void cancelTask(String taskType) {
//        if (taskType == null) {
//            return;
//        }
//        for (int i = taskList.size() - 1; i >= 0; i--) {
//            MyAsyncTask task = taskList.get(i);
//            if (taskType.equals(task.getTaskType())) {
//                taskList.remove(i);
//                task.cancel(true);
//            }
//        }
//    }
}
