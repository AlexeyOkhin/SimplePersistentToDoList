//
//  CategoryViewController.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 01.04.2023.
//

import UIKit
import RealmSwift

private enum Section: CaseIterable {
    case categories
}

class CategoryViewController: UIViewController {

    //MARK: -  Private Properties

    private let realm = try! Realm()

    private lazy var diffDataSource = DifDataSource(listTableView)

    private let fileManager = ToDoFileManager()

    private var testArray = [CategoryModel]()

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


        loadCategories()
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

    private func loadCategories() {

        testArray = realm.objects(CategoryModel.self).map({$0})
        updateDataSource()
    }

    private func save(category: CategoryModel) {

        do {
            try realm.write{
                realm.add(category)
            }
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
            let categoryColour = UIColor.random() 
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = category.name
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
      if editingStyle == .delete {
          do {

              let model = realm.objects(CategoryModel.self)[indexPath.row]//.modelForIndexPath(indexPath)


              var snapshot = self.snapshot()
              snapshot.deleteItems([model])
                  apply(snapshot)
              try realm.write {
                  realm.delete(model)
              }
              
          } catch {
              print(error)
          }
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
            let category = CategoryModel()
            category.name = title
            self.testArray.append(category)
            self.save(category: category)
        }

        alert.addAction(actionButton)
        present(alert, animated: true)
    }
}
