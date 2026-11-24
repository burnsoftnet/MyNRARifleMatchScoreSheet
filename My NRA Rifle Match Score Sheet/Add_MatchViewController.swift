//
//  Add_MatchViewController.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// Add a new match, or edit an existing one.
@objc(Add_MatchViewController)
final class Add_MatchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    /// Match ID ( match_list_cof_details.MLID )
    var mid = ""
    /// To determine if we need to load data or not.
    var isNew = false

    @IBOutlet weak var btnAddMatch: UIButton!
    @IBOutlet weak var txtMatchName: UITextField!
    @IBOutlet weak var txtClass: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtRelay: UITextField!
    @IBOutlet weak var txtTarget: UITextField!

    private var pickerDataSource: [String] = []
    private let pvClass = UIPickerView()
    private let datePicker = UIDatePicker()
    private var dbPath = ""

    /// Load the data and settings when the form loads
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initDatePicker()
        initClassPicker()
    }

    /// Create the initial class Picker and calculate the size of the screen
    private func initClassPicker() {
        // Calculate the screen's width. (The system resizes input views, so this only sets the initial frame.)
        let screenWidth = view.bounds.width
        let pickerWidth = screenWidth * 3 / 4

        // Calculate the starting x coordinate.
        let xPoint = screenWidth / 2 - pickerWidth / 2

        pvClass.dataSource = self
        pvClass.delegate = self

        // Set the picker's frame. We set the y coordinate to 50px.
        pvClass.frame = CGRect(x: xPoint, y: 50, width: pickerWidth, height: 200)

        txtClass.inputView = pvClass
        txtClass.inputAccessoryView = makeDoneToolbar(action: #selector(selectMatchClass))
        txtClass.addTarget(self, action: #selector(classPickerWillShow), for: .editingDidBegin)
    }

    /// Show the division already in the text box (or the first one) when the picker opens
    @objc private func classPickerWillShow() {
        pvClass.reloadAllComponents()
        let row = pickerDataSource.firstIndex(of: txtClass.text ?? "") ?? 0
        if row < pickerDataSource.count {
            pvClass.selectRow(row, inComponent: 0, animated: false)
        }
    }

    /// Toolbar with a trailing Done button for a picker input view
    private func makeDoneToolbar(action: Selector) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar.tintColor = .gray
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: action)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        return toolBar
    }

    /// Pass the Class that is selected in the picker
    @objc private func selectMatchClass() {
        let row = pvClass.selectedRow(inComponent: 0)
        if pickerDataSource.indices.contains(row) {
            txtClass.text = pickerDataSource[row]
        }
        txtClass.resignFirstResponder()
    }

    /// Initialize the Date Picker
    private func initDatePicker() {
        datePicker.datePickerMode = .date
        txtDate.inputView = datePicker
        txtDate.inputAccessoryView = makeDoneToolbar(action: #selector(showSelectedDate))
    }

    /// Pass the date selected to the form
    @objc private func showSelectedDate() {
        let formatter = DateFormatter()
        // "YYYY" (week-based year) is kept from the original so stored dates don't change format.
        formatter.dateFormat = "YYYY-MM-dd"
        txtDate.text = formatter.string(from: datePicker.date)
        txtDate.resignFirstResponder()
    }

    // MARK: View will reappear

    /// Sub when the form reloads
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
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
        FormFunctions.doBuggermeMessage(dbPath, fromSubFunction: "Add_MatchViewController.setupGlobalVars.DatabasePath")
        FormFunctions.setBorderButton(btnAddMatch)
    }

    // MARK: Load Data from Database

    /// Load the data from the database to be displayed on the form when editing
    private func loadData() {
        var errorMsg = ""
        pickerDataSource = MatchLists.getAllMatchClassTypes(databasePath: dbPath, errorMsg: &errorMsg)

        guard !isNew else { return }
        var matchDivisionID: String?
        BurnSoftDatabase.query("SELECT dt,name,location,target,relay,MCID from match_list where ID=\(mid)",
                               databasePath: dbPath,
                               errorPrefix: "Error while creating select statement for Add_MatchViewController.loadData .",
                               errorMsg: &errorMsg) { statement in
            txtDate.text = BurnSoftDatabase.columnString(statement, 0)
            txtMatchName.text = BurnSoftDatabase.columnString(statement, 1)
            txtLocation.text = BurnSoftDatabase.columnString(statement, 2)
            txtTarget.text = BurnSoftDatabase.columnString(statement, 3)
            txtRelay.text = BurnSoftDatabase.columnString(statement, 4)
            matchDivisionID = BurnSoftDatabase.columnString(statement, 5)
        }
        if let matchDivisionID {
            txtClass.text = MatchLists.getMatchClassName(byID: matchDivisionID, databasePath: dbPath, errorMsg: &errorMsg)
        }
    }

    // MARK: PickerView DataSource

    /// number of components in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    /// number of rows in components
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerDataSource.count
    }

    /// title for the row of the component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerDataSource[row]
    }

    // MARK: PickerView Delegate

    /// when the row is selected from the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtClass.text = pickerDataSource[row]
    }

    /// when the button to add the match was clicked
    @IBAction func btnAddMatch(_ sender: Any) {
        var errorMsg = ""
        let matchName = txtMatchName.text ?? ""
        let location = txtLocation.text ?? ""
        let relay = txtRelay.text ?? ""
        let target = txtTarget.text ?? ""
        let dateOfMatch = txtDate.text ?? ""
        let mcid = MatchLists.getMatchClassID(byName: txtClass.text ?? "", databasePath: dbPath, errorMsg: &errorMsg)

        let saved: Bool
        if isNew {
            saved = MatchLists.insertNewMatch(name: matchName, matchClassID: mcid, location: location, relay: relay, target: target, dateOfMatch: dateOfMatch, databasePath: dbPath, errorMsg: &errorMsg)
        } else {
            saved = MatchLists.updateMatch(byID: mid, name: matchName, matchClassID: mcid, location: location, relay: relay, target: target, dateOfMatch: dateOfMatch, databasePath: dbPath, errorMsg: &errorMsg)
        }

        if saved {
            // Pops twice, matching the original navigation behavior.
            navigationController?.popViewController(animated: false)
            navigationController?.popViewController(animated: true)
        } else {
            FormFunctions.checkForError(errorMsg, title: "Adding Match Error", viewController: self)
        }
    }
}
