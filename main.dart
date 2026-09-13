class Task {
  String title;
  String subject;
  bool isCompleted;

  Task(this.title, this.subject, this.isCompleted);

  void displayTask() {
    print('Task: $title');
    print('Subject: $subject');
    print('Status: ${isCompleted ? "Completed" : "Not Completed"}');
    print('-----------------------');
  }
}

void main() {
  Task task1 = Task('Study Chapter 1', 'Programming', false);
  Task task2 = Task('Solve Assignment', 'Mathematics', true);
  Task task3 = Task('Review Lecture', 'Networks', false);

  List<Task> tasks = [task1, task2, task3];

  for (Task task in tasks) {
    task.displayTask();
  }
}
