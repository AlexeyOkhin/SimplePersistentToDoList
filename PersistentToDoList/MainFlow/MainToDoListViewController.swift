//
//  MainToDoListViewController.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 24.03.2023.
//

import UIKit
import CoreData

enum Section: CaseIterable {
    case notes
}

class MainToDoListViewController: UIViewController {

    //MARK: -  Private Properties

    private lazy var diffDataSource = DifDataSource(listTableView)

    private let fileManager = ToDoFileManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var testArray = [NoteModel]()

    private lazy var listTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        return table
    }()



    //MARK: -  Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNavBar()
        settingUI()

        //testArray = ToDoFileManager().readDataArray()
        updateDataSource()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listTableView.frame = view.bounds
    }

//MARK: - UI setup

    private func settingNavBar() {

        title = "Notes"

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddAction))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    private func settingUI() {
        view.addSubview(listTableView)

    }

    private func updateDataSource() {

        var snapshot = diffDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(testArray)
        diffDataSource.apply(snapshot, animatingDifferences: true)
    }

    private func saveData() {

        do {
            try context.save()
        } catch {
            print(error)
        }

        updateDataSource()
    }

    @objc
    private func tapAddAction() {
        addNotesAlert()
    }

}

// MARK: - UITableViewDiffableDataSource

final class DifDataSource: UITableViewDiffableDataSource<Section, NoteModel> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, note in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            cell.accessoryType = note.done ? .checkmark : .none
            cell.textLabel?.text = note.title
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension MainToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        testArray[indexPath.row].done.toggle()
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

//MARK: - Add alert

extension MainToDoListViewController {
    private func addNotesAlert() {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)

        alert.addTextField { alertTF in
            alertTF.placeholder = "Input here..."
            textField = alertTF
        }

        let actionButton = UIAlertAction(title: "Add note", style: .default) { [weak self] alert in
            guard let self else { return }
            let title = textField.text ?? ""
            let note = NoteModel(context: self.context)
            note.done = false
            note.title = title
            self.testArray.append(note)
            self.saveData()
        }

        alert.addAction(actionButton)
        present(alert, animated: true)
    }
}
