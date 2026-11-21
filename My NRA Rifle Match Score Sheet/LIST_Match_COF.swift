//
//  LIST_Match_COF.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// The Courses of Fire recorded for one match.
@objc(LIST_Match_COF)
final class LIST_Match_COF: UITableViewController {

    /// Outlet for the UITableView
    @IBOutlet weak var myTableView: UITableView!
    /// Match ID Container
    var mid = ""

    private var dbPath = ""
    private var matchListings: [MatchListCOF] = []
    private var selectedCellID = ""

    // MARK: View Did Load

    /// Load settings and data when the form loads, Create an Add Button in Nav Bar, Initialize Refresh Control
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalVars()
        myTableView.delegate = self
        myTableView.dataSource = self
        loadData()

        //Create an Add Button in Nav Bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addMatch))

        // Initialize Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }

    // MARK: View will reappear

    /// Sub when the form reloads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    // MARK: Refresh Table Data

    /// when you swipe down on the table, it will reload the data
    @IBAction func refresh(_ sender: UIRefreshControl) {
        myTableView.reloadData()
        loadData()
        sender.endRefreshing()
    }

    // MARK: Add New Course of Fire

    /// add the details of a new course of fire
    @objc private func addMatch() {
        performSegue(withIdentifier: "sequeAddNewMatch", sender: self)
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
        FormFunctions.doBuggermeMessage(dbPath, fromSubFunction: "LIST_Matches.setupGlobalVars.DatabasePath")
        matchListings = []
    }

    // MARK: Load Data from Database

    /// Load Data from the database into an array to be used in the table
    private func loadData() {
        var errorMsg = ""
        matchListings = MatchListCOF.getAllMatchListCOF(byMatchID: mid, databasePath: dbPath, errorMsg: &errorMsg)
        FormFunctions.checkForError(errorMsg, title: "LoadData:", viewController: self)
        myTableView.reloadData()
    }

    // MARK: Navigation

    /// Pass the match and course of fire to the details screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? CourseOfFire_ViewController else { return }
        switch segue.identifier {
        case "segueCOFDetails":
            destination.isNew = false
            destination.mid = mid
            destination.cofID = selectedCellID
        case "sequeAddNewMatch":
            destination.isNew = true
            destination.mid = mid
            destination.cofID = ""
        default:
            break
        }
    }

    // MARK: Table set Edit Mode

    /// Set if you can edit the table by swiping left to view options.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    // MARK: Table Set Sections

    /// set the sections in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    // MARK: Table Set Number of Rows

    /// set the number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !matchListings.isEmpty {
            self.tableView.backgroundView = nil
            return matchListings.count
        }
        // Display a message when the table is empty
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        messageLabel.text = "No data is currently available. Please Add a Course of Fire."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
        messageLabel.sizeToFit()

        self.tableView.backgroundView = messageLabel
        self.tableView.separatorStyle = .none
        return 0
    }

    // MARK: Table Set Cell Data

    /// set the cell data by use of an array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let displayMatch = matchListings[indexPath.row]
        cell.tag = Int(displayMatch.cofID)
        cell.textLabel?.text = displayMatch.cofName
        cell.detailTextLabel?.text = displayMatch.scoreDetails
        return cell
    }

    // MARK: Table Row Selected

    /// actions to take when a row has been selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectedCellID = String(cell.tag)
        performSegue(withIdentifier: "segueCOFDetails", sender: self)
    }

    // MARK: Table Handlers on Swipe

    /// trailing swipe action configuration for table row
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            var errorMsg = ""
            let displayMatch = matchListings[indexPath.row]
            let matchListCOF = MatchListCOF.getCourseOfFireID(byName: displayMatch.cofName, databasePath: dbPath, errorMsg: &errorMsg)
            let cofID = String(displayMatch.cofID)

            if MatchListCOF.deleteMatchCourseOfFire(cofID, matchID: mid, matchListCOF: matchListCOF, databasePath: dbPath, errorMsg: &errorMsg) {
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
}
