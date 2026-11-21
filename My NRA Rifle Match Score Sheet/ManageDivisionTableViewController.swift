//
//  ManageDivisionTableViewController.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// Add, edit and delete match Divisions.
@objc(ManageDivisionTableViewController)
final class ManageDivisionTableViewController: UITableViewController {

    /// Outlet for the UITableView
    @IBOutlet weak var myTableView: UITableView!

    private var dbPath = ""
    private var matchDivisions: [ManageDivisions] = []

    /// Load Data and settings when the form first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalVars()
        myTableView.delegate = self
        myTableView.dataSource = self
        loadData()

        //Create an Add Button in Nav Bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addDivision))

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
        matchDivisions = []
    }

    // MARK: Load Data from Database

    /// Load the data from the database into an array to be used in the table.
    private func loadData() {
        var errorMsg = ""
        matchDivisions = ManageDivisions.getAllDivisions(databasePath: dbPath, errorMsg: &errorMsg)
        FormFunctions.checkForError(errorMsg, title: "LoadData:", viewController: self)
        myTableView.reloadData()
    }

    // MARK: Add New Division

    /// Prompt for the name of a new division
    @objc private func addDivision() {
        let alertController = UIAlertController(title: "Divisions", message: "Add Division", preferredStyle: .alert)
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
            if ManageDivisions.addDivisionName(name, databasePath: dbPath, errorMsg: &errorMsg) {
                reloadData()
            } else {
                FormFunctions.checkForError(errorMsg, title: "Error Adding", viewController: self)
            }
        })
        present(alertController, animated: true)
    }

    // MARK: Table view data source

    /// Number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    /// number of rows in the section of the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchDivisions.count
    }

    /// Load the cells of the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let displayDivision = matchDivisions[indexPath.row]
        cell.tag = Int(displayDivision.divID)
        cell.textLabel?.text = displayDivision.divisionName
        return cell
    }

    // MARK: Table set Edit Mode

    /// Set if you can edit the table by swiping left to view options.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    // MARK: Table Handlers on Swipe

    /// trailing swipe action configuration for table row; a division in use can't be deleted
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            var errorMsg = ""
            let divID = String(matchDivisions[indexPath.row].divID)
            let divisionName = ManageDivisions.getDivision(byID: divID, databasePath: dbPath, errorMsg: &errorMsg)
            let sql = "select * from match_list where MCID=\(divID)"
            if BurnSoftDatabase.dataExistsbyQuery(sql, databasePath: dbPath, message: &errorMsg) {
                FormFunctions.sendMessage("Can't Delete \(divisionName), Disivion is in Use!", title: "Can't Delete!", viewController: self)
            } else if ManageDivisions.deleteDivision(byID: divID, databasePath: dbPath, errorMsg: &errorMsg) {
                reloadData()
            } else {
                FormFunctions.checkForError(errorMsg, title: "Error Deleting Division", viewController: self)
            }
        }
        deleteAction.backgroundColor = FormFunctions.setDeleteColor()

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }

    // MARK: Table Row Selected

    /// Prompt to rename the selected division
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var errorMsg = ""
        let divID = String(cell.tag)
        let divisionName = ManageDivisions.getDivision(byID: divID, databasePath: dbPath, errorMsg: &errorMsg)

        let alertController = UIAlertController(title: "Division", message: "Edit Division", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "name"
            textField.textColor = .blue
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
            textField.text = divisionName
        }
        alertController.addAction(UIAlertAction(title: "Update", style: .default) { [unowned self, unowned alertController] _ in
            var errorMsg = ""
            let name = alertController.textFields?.first?.text ?? ""
            if ManageDivisions.updateDivisionName(name, divisionID: divID, databasePath: dbPath, errorMsg: &errorMsg) {
                reloadData()
            } else {
                FormFunctions.checkForError(errorMsg, title: "Error Editing", viewController: self)
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}
