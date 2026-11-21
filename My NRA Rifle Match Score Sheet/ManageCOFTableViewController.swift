//
//  ManageCOFTableViewController.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// Add, edit and delete Course of Fire types.
@objc(ManageCOFTableViewController)
final class ManageCOFTableViewController: UITableViewController {

    /// Outlet for the UITableView
    @IBOutlet weak var myTableView: UITableView!

    private var dbPath = ""
    private var matchCOF: [ManageCOF] = []

    /// When the form loads, Create an Add Button in Nav Bar, Initialize Refresh Control
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalVars()
        myTableView.delegate = self
        myTableView.dataSource = self
        loadData()

        //Create an Add Button in Nav Bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addCOF))

        // Initialize Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }

    // MARK: Refresh Table Data

    /// when you swipe down on the table, it will reload the data
    @IBAction func refresh(_ sender: UIRefreshControl) {
        myTableView.reloadData()
        loadData()
        sender.endRefreshing()
    }

    // MARK: Reload Data

    /// Reload the data as is the for first appeared
    private func reloadData() {
        setupGlobalVars()
        loadData()
    }

    // MARK: Setup Global Variables

    /// Setup the global variables like the database path
    private func setupGlobalVars() {
        dbPath = BurnSoftDatabase.getDatabasePath(MYSettings.dbName)
        FormFunctions.doBuggermeMessage(dbPath, fromSubFunction: "ManageCOFTableViewController.setupGlobalVars.DatabasePath")
        matchCOF = []
    }

    // MARK: Load Data from Database

    /// Load the data from the database into an array to be used in the table.
    private func loadData() {
        var errorMsg = ""
        matchCOF = ManageCOF.getAllCourseOfFire(databasePath: dbPath, errorMsg: &errorMsg)
        FormFunctions.checkForError(errorMsg, title: "LoadData:", viewController: self)
        myTableView.reloadData()
    }

    // MARK: Add New Course of Fire

    /// Prompt for the name of a new course of fire
    @objc private func addCOF() {
        let alertController = UIAlertController(title: "Course of Fire", message: "Add Course of Fire", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "name"
            textField.textColor = .blue
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "ADD", style: .default) { [unowned self, unowned alertController] _ in
            var errorMsg = ""
            let name = alertController.textFields?.first?.text ?? ""
            if ManageCOF.addCOFName(name, databasePath: dbPath, errorMsg: &errorMsg) {
                reloadData()
            } else {
                FormFunctions.checkForError(errorMsg, title: "Error Adding", viewController: self)
            }
        })
        present(alertController, animated: true)
    }

    // MARK: Table view data source

    /// Set the Number of section in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    /// Set the number of rows in Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchCOF.count
    }

    /// Set the data for the cell of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let displayCOF = matchCOF[indexPath.row]
        cell.tag = Int(displayCOF.cofID)
        cell.textLabel?.text = displayCOF.cofName
        return cell
    }

    // MARK: Table set Edit Mode

    /// Set if you can edit the table by swiping left to view options.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    // MARK: Table Handlers on Swipe

    /// trailing swipe action configuration for table row; a course of fire in use can't be deleted
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            var errorMsg = ""
            let cofID = String(matchCOF[indexPath.row].cofID)
            let cofName = ManageCOF.getCourseOfFire(byID: cofID, databasePath: dbPath, errorMsg: &errorMsg)
            let sql = "select * from match_list_cof_details where MCOFID=\(cofID)"
            if BurnSoftDatabase.dataExistsbyQuery(sql, databasePath: dbPath, message: &errorMsg) {
                FormFunctions.sendMessage("Can't Delete \(cofName), Course of Fire is in Use!", title: "Can't Delete!", viewController: self)
            } else if ManageCOF.deleteCOF(byID: cofID, databasePath: dbPath, errorMsg: &errorMsg) {
                reloadData()
            } else {
                FormFunctions.checkForError(errorMsg, title: "Error Deleting COF", viewController: self)
            }
        }
        deleteAction.backgroundColor = FormFunctions.setDeleteColor()

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }

    // MARK: Table Row Selected

    /// Prompt to rename the selected course of fire
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var errorMsg = ""
        let cofID = String(cell.tag)
        let cofName = ManageCOF.getCourseOfFire(byID: cofID, databasePath: dbPath, errorMsg: &errorMsg)

        let alertController = UIAlertController(title: "Course of Fire", message: "Edit Course of Fire", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "name"
            textField.textColor = .blue
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
            textField.text = cofName
        }
        alertController.addAction(UIAlertAction(title: "Update", style: .default) { [unowned self, unowned alertController] _ in
            var errorMsg = ""
            let name = alertController.textFields?.first?.text ?? ""
            if ManageCOF.updateCOFName(name, courseOfFireID: cofID, databasePath: dbPath, errorMsg: &errorMsg) {
                reloadData()
            } else {
                FormFunctions.checkForError(errorMsg, title: "Error Editing", viewController: self)
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}
