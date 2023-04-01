//
//  CategoryViewController.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 01.04.2023.
//

import UIKit
import CoreData

private enum Section: CaseIterable {
    case categories
}

class CategoryViewController: UIViewController {

    //MARK: -  Private Properties

    private lazy var diffDataSource = DifDataSource(listTableView)

    private let fileManager = ToDoFileManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var testArray = [CategoryModel]()

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

        title = "Categories"

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

    private func loadNotes(with request: NSFetchRequest<CategoryModel> = CategoryModel.fetchRequest()) {
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
        addCategoryAlert()
    }

}

// MARK: - UITableViewDiffableDataSource

final private class DifDataSource: UITableViewDiffableDataSource<Section, CategoryModel> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, category in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            cell.textLabel?.text = category.name
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = testArray[indexPath.row]
        let notesVC = MainToDoListViewController()
        notesVC.selectedCategory = selectedCategory
        navigationController?.pushViewController(notesVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Add alert

extension CategoryViewController {
    private func addCategoryAlert() {

        var textField = UITextField()

        let alert = UIAlertController(title: "Category", message: "", preferredStyle: .alert)

        alert.addTextField { alertTF in
            alertTF.placeholder = "Input here..."
            textField = alertTF
        }

        let actionButton = UIAlertAction(title: "Add Category", style: .default) { [weak self] alert in
            guard let self else { return }
            let title = textField.text ?? ""
            let category = CategoryModel(context: self.context)
            category.name = title
            self.testArray.append(category)
            self.saveData()
        }

        alert.addAction(actionButton)
        present(alert, animated: true)
    }
}

