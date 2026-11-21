//
//  LIST_Matches.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// List of matches, grouped into sections by division.
@objc(LIST_Matches)
final class LIST_Matches: UITableViewController {

    /// Outlet for the UITableView
    @IBOutlet weak var myTableView: UITableView!

    /// Group the matches by division (section per division)
    private let useGrouping = true

    private var dbPath = ""
    private var matchListings: [MatchLists] = []
    /// Division names used as section titles, sorted case-insensitively
    private var matchClasses: [String] = []
    /// Matches for each division keyed by division name
    private var matchesByClass: [String: [MatchLists]] = [:]
    private var selectedCellID = ""

    // MARK: View Did Load

    /// load settings and data when the form loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalVars()
        myTableView.delegate = self
        myTableView.dataSource = self
        loadData()

        // Initialize Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }

    /// Add navigation button to the top to allow an add button
    private func addNavButton() {
        if MYSettings.isLiteVersion() && matchListings.count > MYSettings.liteLimit - 1 {
            navigationItem.rightBarButtonItem = nil
            FormFunctions.alertOnLimit(for: self)
        } else {
            //Create an Add Button in Nav Bar
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addMatch))
        }
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
        addNavButton()
    }

    // MARK: Add New Match

    /// add the details of a new match
    @objc private func addMatch() {
        performSegue(withIdentifier: "sequeAddNewMatch", sender: self)
    }

    // MARK: Reload Data

    /// Reload the data as is the for first appeared
    private func reloadData() {
        setupGlobalVars()
        loadData()
        addNavButton()
    }

    // MARK: Setup Global Variables

    /// Setup the global variablies like the database path
    private func setupGlobalVars() {
        dbPath = BurnSoftDatabase.getDatabasePath(MYSettings.dbName)
        FormFunctions.doBuggermeMessage(dbPath, fromSubFunction: "LIST_Matches.setupGlobalVars.DatabasePath")
        matchListings = []
    }

    // MARK: Load Data from Database

    /// Load the data from the database into the arrays used by the table
    private func loadData() {
        var errorMsg = ""

        matchListings = MatchLists.getAllMatchLists(databasePath: dbPath, errorMsg: &errorMsg)
        FormFunctions.checkForError(errorMsg, title: "LoadData:", viewController: self)

        let distinctClasses = MatchLists.getDistinctMatchClasses(databasePath: dbPath, errorMsg: &errorMsg)
        FormFunctions.checkForError(errorMsg, title: "Error Load Data Match Class:", viewController: self)

        setupDictionary(distinctClasses)
        matchClasses = matchesByClass.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }

        myTableView.reloadData()
    }

    /// Setup the Match Classes
    private func setupDictionary(_ classes: [String]) {
        var errorMsg = ""
        matchesByClass = [:]
        for className in classes {
            matchesByClass[className] = MatchLists.getAllMatchLists(byMatchDivision: className, databasePath: dbPath, errorMsg: &errorMsg)
        }
    }

    /// The match shown at `indexPath`
    private func match(at indexPath: IndexPath) -> MatchLists {
        if useGrouping {
            return matchesByClass[matchClasses[indexPath.section], default: []][indexPath.row]
        }
        return matchListings[indexPath.row]
    }

    // MARK: Prepare for Segue

    /// Actions to take before switching to the next window
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueShowCourseOfFire":
            if let destination = segue.destination as? LIST_Match_COF {
                destination.mid = selectedCellID
            }
        case "sequeAddNewMatch":
            if let destination = segue.destination as? Add_MatchViewController {
                destination.isNew = true
            }
        case "segueEditMatch":
            if let destination = segue.destination as? Add_MatchViewController {
                destination.mid = selectedCellID
                destination.isNew = false
            }
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
        guard useGrouping else { return 1 }
        if matchClasses.isEmpty {
            // Display a message when the table is empty
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "No data is currently available. Please Add a Match."
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            messageLabel.sizeToFit()

            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = .none
            return 0
        }
        return matchClasses.count
    }

    // MARK: Table Set Number of Rows

    /// set the number of rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if useGrouping {
            return matchesByClass[matchClasses[section]]?.count ?? 0
        }
        return matchListings.count
    }

    /// the title for the header in the section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        useGrouping ? matchClasses[section] : nil
    }

    // MARK: Table Set Cell Data

    /// set the cell data by use of an array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let displayMatch = match(at: indexPath)

        cell.tag = Int(displayMatch.mid)
        cell.textLabel?.text = displayMatch.matchName
        cell.detailTextLabel?.text = displayMatch.matchDetails
        return cell
    }

    // MARK: Table Row Selected

    /// actions to take when a row has been selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectedCellID = String(cell.tag)
        performSegue(withIdentifier: "segueShowCourseOfFire", sender: self)
    }

    // MARK: Table Handlers on Swipe

    /// trailing swipe action configuration for table row: Edit, Delete and Copy
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            var errorMsg = ""
            let mid = String(match(at: indexPath).mid)
            if MatchLists.deleteMatchLists(byID: mid, databasePath: dbPath, errorMsg: &errorMsg) {
                reloadData()
            } else {
                FormFunctions.checkForError(errorMsg, title: "Error Deleting Match", viewController: self)
            }
        }

        let editAction = UIContextualAction(style: .destructive, title: "Edit") { [unowned self] _, _, _ in
            guard let destination = storyboard?.instantiateViewController(withIdentifier: "sbAddMatch") as? Add_MatchViewController else { return }
            destination.mid = String(match(at: indexPath).mid)
            navigationController?.pushViewController(destination, animated: true)
        }

        let copyAction = UIContextualAction(style: .destructive, title: "Copy") { [unowned self] _, _, _ in
            var errorMsg = ""
            MatchLists.copyMatch(byMatchID: String(match(at: indexPath).mid), databasePath: dbPath, errorMsg: &errorMsg)
            reloadData()
        }

        deleteAction.backgroundColor = FormFunctions.setDeleteColor()
        editAction.backgroundColor = FormFunctions.setEditColor()
        copyAction.backgroundColor = FormFunctions.setEditColor()

        let swipeActions = UISwipeActionsConfiguration(actions: [editAction, deleteAction, copyAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}
