//
//  MainToDoListViewController.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 24.03.2023.
//

import UIKit

enum Section: CaseIterable {
    case notes
}

class MainToDoListViewController: UIViewController {

    //MARK: -  Private Properties



    private lazy var diffDataSource = DifDataSource(listTableView)

    private let fileManager = ToDoFileManager()

    private var testArray = [Note]()

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
        testArray = ToDoFileManager().readDataArray()
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

    @objc
    private func tapAddAction() {
        addNotesAlert()
    }
}

// MARK: - UITableViewDelegate

final class DifDataSource: UITableViewDiffableDataSource<Section, Note> {
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
        fileManager.writeDataArray(dataArray: testArray)
        updateDataSource()
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
            let title = textField.text ?? ""
            let note = Note(title: title)

            self?.testArray.append(note)
            self?.fileManager.writeDataArray(dataArray: self?.testArray)
            self?.updateDataSource()
        }

        alert.addAction(actionButton)
        present(alert, animated: true)
    }
}
