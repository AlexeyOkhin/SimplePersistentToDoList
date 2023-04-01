//
//  MainToDoListViewController.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 24.03.2023.
//

import UIKit
import CoreData

private enum Section: CaseIterable {
    case notes
}

class MainToDoListViewController: UIViewController {

    //MARK: - Properties

    var selectedCategory: CategoryModel?

    //MARK: -  Private Properties

    private lazy var diffDataSource = DifDataSource(listTableView)

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var testArray = [NoteModel]()



    private var resultSearchController = UISearchController()

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
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            //controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear
            controller.searchBar.delegate = self
            self.listTableView.tableHeaderView = controller.searchBar
            return controller
        })()

        settingUI()
        loadNotes()
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

        navigationItem.hidesSearchBarWhenScrolling = true

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

    private func loadNotes(with request: NSFetchRequest<NoteModel> = NoteModel.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let addPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
           testArray = try context.fetch(request)
        } catch {
            print(error)
        }
        updateDataSource()
    }

    private func saveData() {

        do {
            try context.save()
            updateDataSource()
        } catch {
            print(error)
        }
    }

    @objc
    private func tapAddAction() {
        addNotesAlert()
    }

}

// MARK: - UITableViewDiffableDataSource

final private class DifDataSource: UITableViewDiffableDataSource<Section, NoteModel> {
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
        tableView.reloadData()
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
            note.parentCategory = self.selectedCategory
            self.testArray.append(note)
            self.saveData()
        }

        alert.addAction(actionButton)
        present(alert, animated: true)
    }
}


//MARK: - add UISearchResultsUpdating

extension MainToDoListViewController:  UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<NoteModel> = NoteModel.fetchRequest()
        let predicat = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        request.predicate = predicat

        let descriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [descriptor]

        loadNotes(with: request, predicate: predicat)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadNotes()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}
