//
//  CourseOfFire_ViewController.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/9/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// Score sheet for a single Course of Fire: 2 sighters and 20 shots for record in two strings of 10.
@objc(CourseOfFire_ViewController)
final class CourseOfFire_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

    /// Course of Fire Details ID ( match_list_cof_details.ID )
    var cofID = ""
    /// Match ID ( match_list_cof_details.MLID )
    var mid = ""
    /// To determine if we need to load data or not.
    var isNew = false

    //Form General
    @IBOutlet weak var btnApply: UIButton!
    /// Course of Fire TextBox
    @IBOutlet weak var txtCourseOfFire: UITextField!

    //Sighters Input 1-2
    @IBOutlet weak var txtS1: UITextField!
    @IBOutlet weak var txtS2: UITextField!
    @IBOutlet weak var swXS1: UISwitch!
    @IBOutlet weak var swXS2: UISwitch!

    //For Record 1- 20
    @IBOutlet weak var txtR1: UITextField!
    @IBOutlet weak var txtR2: UITextField!
    @IBOutlet weak var txtR3: UITextField!
    @IBOutlet weak var txtR4: UITextField!
    @IBOutlet weak var txtR5: UITextField!
    @IBOutlet weak var txtR6: UITextField!
    @IBOutlet weak var txtR7: UITextField!
    @IBOutlet weak var txtR8: UITextField!
    @IBOutlet weak var txtR9: UITextField!
    @IBOutlet weak var txtR10: UITextField!
    @IBOutlet weak var txtR11: UITextField!
    @IBOutlet weak var txtR12: UITextField!
    @IBOutlet weak var txtR13: UITextField!
    @IBOutlet weak var txtR14: UITextField!
    @IBOutlet weak var txtR15: UITextField!
    @IBOutlet weak var txtR16: UITextField!
    @IBOutlet weak var txtR17: UITextField!
    @IBOutlet weak var txtR18: UITextField!
    @IBOutlet weak var txtR19: UITextField!
    @IBOutlet weak var txtR20: UITextField!

    @IBOutlet weak var swXR1: UISwitch!
    @IBOutlet weak var swXR2: UISwitch!
    @IBOutlet weak var swXR3: UISwitch!
    @IBOutlet weak var swXR4: UISwitch!
    @IBOutlet weak var swXR5: UISwitch!
    @IBOutlet weak var swXR6: UISwitch!
    @IBOutlet weak var swXR7: UISwitch!
    @IBOutlet weak var swXR8: UISwitch!
    @IBOutlet weak var swXR9: UISwitch!
    @IBOutlet weak var swXR10: UISwitch!
    @IBOutlet weak var swXR11: UISwitch!
    @IBOutlet weak var swXR12: UISwitch!
    @IBOutlet weak var swXR13: UISwitch!
    @IBOutlet weak var swXR14: UISwitch!
    @IBOutlet weak var swXR15: UISwitch!
    @IBOutlet weak var swXR16: UISwitch!
    @IBOutlet weak var swXR17: UISwitch!
    @IBOutlet weak var swXR18: UISwitch!
    @IBOutlet weak var swXR19: UISwitch!
    @IBOutlet weak var swXR20: UISwitch!

    //Totals
    @IBOutlet weak var lblString1Total: UILabel!
    @IBOutlet weak var lblString2Total: UILabel!
    @IBOutlet weak var lblCOFTotal: UILabel!
    @IBOutlet weak var lblXTotal: UILabel!
    @IBOutlet weak var lblXTotal2: UILabel!

    /// Course of Fire Data Source
    private var courseOfFireDataSource: [String] = []
    private let pvCourseOfFire = UIPickerView()
    private var dbPath = ""
    /// match_list_cof.ID of the course of fire being edited
    private var matchListCOFID = ""

    /// Sighter score boxes paired with their X switches
    private var sighters: [(field: UITextField, xSwitch: UISwitch)] {
        [(txtS1, swXS1), (txtS2, swXS2)]
    }

    /// Record score boxes 1-20 paired with their X switches; 1-10 are string 1 and 11-20 are string 2
    private var records: [(field: UITextField, xSwitch: UISwitch)] {
        [(txtR1, swXR1), (txtR2, swXR2), (txtR3, swXR3), (txtR4, swXR4), (txtR5, swXR5),
         (txtR6, swXR6), (txtR7, swXR7), (txtR8, swXR8), (txtR9, swXR9), (txtR10, swXR10),
         (txtR11, swXR11), (txtR12, swXR12), (txtR13, swXR13), (txtR14, swXR14), (txtR15, swXR15),
         (txtR16, swXR16), (txtR17, swXR17), (txtR18, swXR18), (txtR19, swXR19), (txtR20, swXR20)]
    }

    // MARK: View Did Load

    /// Load the settings and database when the form loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlobalVars()
        loadData()
        startPicker()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapReceived(_:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: Keyboard Tapped

    /// Dismiss the keyboard when the view is selected
    @objc private func tapReceived(_ tapGestureRecognizer: UITapGestureRecognizer) {
        for entry in sighters + records {
            entry.field.resignFirstResponder()
        }
    }

    // MARK: Start Picker

    /// Start the Course of Fire picker and attach it to the Course of Fire text box
    private func startPicker() {
        // Calculate the screen's width. (The system resizes input views, so this only sets the initial frame.)
        let screenWidth = view.bounds.width
        let pickerWidth = screenWidth * 3 / 4

        // Calculate the starting x coordinate.
        let xPoint = screenWidth / 2 - pickerWidth / 2

        pvCourseOfFire.dataSource = self
        pvCourseOfFire.delegate = self

        // Set the picker's frame. We set the y coordinate to 50px.
        pvCourseOfFire.frame = CGRect(x: xPoint, y: 50, width: pickerWidth, height: 200)

        txtCourseOfFire.inputView = pvCourseOfFire
        txtCourseOfFire.addTarget(self, action: #selector(courseOfFirePickerWillShow), for: .editingDidBegin)

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar.tintColor = .gray
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(selectCourseOfFireDataSource))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        txtCourseOfFire.inputAccessoryView = toolBar
    }

    // MARK: Select COF

    /// Show the course of fire already in the text box (or the first one) when the picker opens
    @objc private func courseOfFirePickerWillShow() {
        pvCourseOfFire.reloadAllComponents()
        let row = courseOfFireDataSource.firstIndex(of: txtCourseOfFire.text ?? "") ?? 0
        if row < courseOfFireDataSource.count {
            pvCourseOfFire.selectRow(row, inComponent: 0, animated: false)
        }
    }

    /// Use the course of fire selected in the picker and close it
    @objc private func selectCourseOfFireDataSource() {
        let row = pvCourseOfFire.selectedRow(inComponent: 0)
        if courseOfFireDataSource.indices.contains(row) {
            txtCourseOfFire.text = courseOfFireDataSource[row]
        }
        txtCourseOfFire.resignFirstResponder()
    }

    // MARK: Setup Global Variables

    /// Setup the global variables like the database path
    private func setupGlobalVars() {
        dbPath = BurnSoftDatabase.getDatabasePath(MYSettings.dbName)
        FormFunctions.doBuggermeMessage(dbPath, fromSubFunction: "CourseOfFire_ViewController.setupGlobalVars.DatabasePath")
        FormFunctions.setBorderButton(btnApply)
    }

    // MARK: Set The Hit Factor Value

    /// Used when Loading data, pass the value that is stored in the database, if it is an x it will flip the switch on and set the text value to 10 otherwise it will set the textbox to the value and turn the switch off.
    private func setHitFactor(byValue value: String, textBox: UITextField, xSwitch: UISwitch) {
        if value == "x" {
            xSwitch.isOn = true
            textBox.text = "10"
        } else {
            xSwitch.isOn = false
            textBox.text = value
        }
    }

    // MARK: Get Value from TextBox or Switch

    /// Get the value from the textbox unless the value is an x then return x
    private func getValue(fromTextBox textBox: UITextField, xSwitch: UISwitch) -> String {
        if xSwitch.isOn {
            return "x"
        }
        let value = textBox.text ?? ""
        return value.isEmpty ? "0" : value
    }

    // MARK: Add Value from TextBox

    /// Score of a shot for adding up; an X counts as 10 and also sets the box to 10.
    /// - Returns: the score text and whether it was an X
    private func addValue(fromTextBox textBox: UITextField, xSwitch: UISwitch) -> (score: String, isX: Bool) {
        if xSwitch.isOn {
            textBox.text = "10"
            return ("10", true)
        }
        return (textBox.text ?? "", false)
    }

    // MARK: Load Data

    /// If this is not a new form, it will run this sub to load the data from the database based on the Course Of Fire ID ( COFID )
    private func loadData() {
        var errorMsg = ""
        courseOfFireDataSource = MatchListCOF.getAllMatchCourseOfFireTypes(databasePath: dbPath, errorMsg: &errorMsg)

        guard !isNew else { return }
        let sql = "SELECT ID, MCOFID,cof,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,x_count_1,x_count_2,MLCID from view_match_list_cof_details where ID=\(cofID)"
        BurnSoftDatabase.query(sql,
                               databasePath: dbPath,
                               errorPrefix: "Error while creating select statement for CourseOfFire_ViewController.loadData .",
                               errorMsg: &errorMsg) { statement in
            txtCourseOfFire.text = BurnSoftDatabase.columnString(statement, 2)

            //sighters 1-2 are columns 3-4
            for (index, sighter) in sighters.enumerated() {
                setHitFactor(byValue: BurnSoftDatabase.columnString(statement, Int32(3 + index)), textBox: sighter.field, xSwitch: sighter.xSwitch)
            }
            //records 1-20 are columns 5-24
            for (index, record) in records.enumerated() {
                setHitFactor(byValue: BurnSoftDatabase.columnString(statement, Int32(5 + index)), textBox: record.field, xSwitch: record.xSwitch)
            }

            lblString1Total.text = BurnSoftDatabase.columnString(statement, 25)
            lblString2Total.text = BurnSoftDatabase.columnString(statement, 26)
            lblCOFTotal.text = BurnSoftDatabase.columnString(statement, 27)
            lblXTotal.text = BurnSoftDatabase.columnString(statement, 28)
            lblXTotal2.text = BurnSoftDatabase.columnString(statement, 29)

            //MLCID or Match List COF List ID
            matchListCOFID = BurnSoftDatabase.columnString(statement, 30)
        }
    }

    // MARK: Add All Fields

    /// Add up all the fields to produce the final results
    private func addAllFields() {
        // Sighters don't count toward the score, but an X still sets the box to 10.
        for sighter in sighters {
            _ = addValue(fromTextBox: sighter.field, xSwitch: sighter.xSwitch)
        }

        /// Total score and X count for a string of shots
        func total(_ shots: ArraySlice<(field: UITextField, xSwitch: UISwitch)>) -> (score: String, xCount: String) {
            var score = ""
            var xCount = "0"
            for shot in shots {
                let value = addValue(fromTextBox: shot.field, xSwitch: shot.xSwitch)
                score = BurnSoftMath.addTwoItemsAsIntegerString(score, value.score)
                xCount = BurnSoftMath.addTwoItemsAsIntegerString(xCount, value.isX ? "1" : "0")
            }
            return (score, xCount)
        }

        let allRecords = records
        let string1 = total(allRecords[0..<10])
        lblXTotal.text = string1.xCount
        lblString1Total.text = string1.score

        let string2 = total(allRecords[10..<20])
        lblXTotal2.text = string2.xCount
        lblString2Total.text = string2.score

        lblCOFTotal.text = BurnSoftMath.addTwoItemsAsIntegerString(string1.score, string2.score)
    }

    // MARK: Button Update

    /// When the Update Status button is clicked or touched
    @IBAction func btnUpdateStatus(_ sender: Any) {
        addAllFields()
    }

    // MARK: Button Apply

    /// Called Apply because it can be used in both adding new or updating existing.
    @IBAction func btnApply(_ sender: Any) {
        var errorMessage = ""
        addAllFields()

        let mcofID = MatchListCOF.getCourseOfFireID(byName: txtCourseOfFire.text ?? "", databasePath: dbPath, errorMsg: &errorMessage)

        let sighterValues = sighters.map { getValue(fromTextBox: $0.field, xSwitch: $0.xSwitch) }
        let recordValues = records.map { getValue(fromTextBox: $0.field, xSwitch: $0.xSwitch) }

        let total1 = lblString1Total.text ?? ""
        let total2 = lblString2Total.text ?? ""
        let endTotal = lblCOFTotal.text ?? ""
        let xTotal1 = lblXTotal.text ?? ""
        let xTotal2 = lblXTotal2.text ?? ""
        let xTotal = BurnSoftMath.addTwoItemsAsIntegerString(xTotal1, xTotal2)

        let sql: String
        if isNew {
            let mlcid = MatchListCOF.insertCourseOfFireIDfromList(byMatchID: mid, cofID: mcofID, databasePath: dbPath, errorMsg: &errorMessage)
            let shotValues = (sighterValues + recordValues).map { "'\($0)'" }.joined(separator: ",")
            sql = "INSERT INTO match_list_cof_details(MLCID,MLID,MCOFID,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,x_count_1,x_count_2,xtotal) VALUES(\(mlcid),\(mid),\(mcofID),\(shotValues),\(total1),\(total2),\(endTotal),\(xTotal1),\(xTotal2),\(xTotal));"
        } else {
            BurnSoftDatabase.runQuery("update match_list_cof set MCOFID=\(mcofID) where ID=\(matchListCOFID)", databasePath: dbPath, message: &errorMessage)

            let shotNames = ["s1", "s2"] + (1...20).map { "r\($0)" }
            let shotAssignments = zip(shotNames, sighterValues + recordValues).map { "\($0)='\($1)'" }.joined(separator: ",")
            sql = "UPDATE match_list_cof_details set MLCID=\(matchListCOFID),MLID=\(mid),MCOFID=\(mcofID),\(shotAssignments),total1=\(total1),total2=\(total2),endtotal=\(endTotal),x_count_1=\(xTotal1),x_count_2=\(xTotal2),xtotal=\(xTotal) where ID=\(cofID);"
        }

        if BurnSoftDatabase.runQuery(sql, databasePath: dbPath, message: &errorMessage) {
            navigationController?.popViewController(animated: false)
        } else {
            FormFunctions.checkForError(errorMessage, title: "Error Creating new Course of Fire", viewController: self)
        }
    }

    // MARK: Picker

    /// Number of components.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    /// Total rows in our component.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        courseOfFireDataSource.count
    }

    /// Display each row's data.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        courseOfFireDataSource[row]
    }

    /// Do something with the selected row.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCourseOfFire.text = courseOfFireDataSource[row]
    }
}
