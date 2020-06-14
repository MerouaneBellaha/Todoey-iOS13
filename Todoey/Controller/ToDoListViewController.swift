//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

final class ToDoListViewController: UITableViewController {

    // MARK: - Properties

    private var tasks: [Task] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    var coreDataManager: CoreDataManager?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataManager = CoreDataManager(with: context)

        guard let loadedItems: [Task] = coreDataManager?.loadItems() else { return }
        tasks = loadedItems
    }
    
    // MARK: - IBAction

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        displayAddTaskAlert()
    }

    // MARK: - Methods

    private func displayAddTaskAlert() {
        let alert = UIAlertController(title: nil, message: "Add a task", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Write your task here" }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                !task.isEmpty else { return }

            self.manageNewTask(task: task)

        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    // Move to model ( TaskManager? ) ?
    private func manageNewTask(task: String) {
        let newTask = Task(context: context)
        newTask.taskName = task
        newTask.taskIsDone = false

        tasks.append(newTask)
        coreDataManager?.saveTasks()
    }

// Moved to CoreDataManager

//    private func saveTasks() {
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }

//    private func loadItems() {
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        do {
//            tasks = try context.fetch(request)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }


    // MARK: - TableView Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].taskName

        cell.accessoryType = tasks[indexPath.row].taskIsDone ? .checkmark : .none

        return cell
    }

    // MARK: - Tableview Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].taskIsDone.toggle()

//        context.delete(tasks[indexPath.row])
//        tasks.remove(at: indexPath.row)

        coreDataManager?.saveTasks()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

