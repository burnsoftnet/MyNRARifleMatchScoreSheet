//
//  BurnSoftMath.swift
//  BurnSoftMath
//
//  Created by burnsoft on 1/31/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import Foundation

extension String {
    /// Lenient integer conversion matching `-[NSString intValue]`:
    /// leading digits are used, anything unparseable (including "") is 0.
    var intValue: Int32 { (self as NSString).intValue }

    /// Lenient double conversion matching `-[NSString doubleValue]`.
    var doubleValue: Double { (self as NSString).doubleValue }
}

/// String based math helpers used for score totals.
final class BurnSoftMath {

    // MARK: Get Price Per Item

    /// Pass the price and qty to have it broken down to Price per item
    /// - Returns: a double with two decimal
    static func getPricePerItem(_ price: String, _ qty: String) -> Double {
        getPricePerItemString(price, qty).doubleValue
    }

    // MARK: Multiply Two Items

    /// Pass two values to have them multiplied
    static func multiplyTwoItems(_ itemOne: String, _ itemTwo: String) -> Int32 {
        itemOne.intValue &* itemTwo.intValue
    }

    // MARK: Multiply Two Items as Double Two Decimals

    /// Pass two values to have them multiplied
    /// - Returns: a double with two decimal
    static func multiplyTwoItems2DecDouble(_ itemOne: String, _ itemTwo: String) -> Double {
        multiplyTwoItems2DecDoubleString(itemOne, itemTwo).doubleValue
    }

    // MARK: Multiply Two Items as Double

    /// Pass two values to have them multiplied
    /// - Returns: full double value
    static func multiplyTwoItemsFullDouble(_ itemOne: String, _ itemTwo: String) -> Double {
        itemOne.doubleValue * itemTwo.doubleValue
    }

    // MARK: Add two Values as Integer

    /// Pass two string values to return as intenger
    static func addTwoItemsAsInteger(_ itemOne: String, _ itemTwo: String) -> Int32 {
        itemOne.intValue &+ itemTwo.intValue
    }

    // MARK: Add Two Values as Double

    /// Pass Two string values to return as double
    static func addTwoItemsAsDouble(_ itemOne: String, _ itemTwo: String) -> Double {
        itemOne.doubleValue + itemTwo.doubleValue
    }

    // MARK: Convert Double To String

    /// Convert a Double Value to a string
    static func convertDoubleToString(_ value: Double) -> String {
        String(format: "%f", value)
    }

    // MARK: Get Price per item as String

    /// Pass the price and qty to have it broken down to Price per item
    /// - Returns: a string with two decimal
    static func getPricePerItemString(_ price: String, _ qty: String) -> String {
        String(format: "%.2f", price.doubleValue / qty.doubleValue)
    }

    // MARK: Multiply Two Strings to Return String

    /// Pass two string values to multiply and return the value as string
    static func multiplyTwoItemsString(_ itemOne: String, _ itemTwo: String) -> String {
        String(multiplyTwoItems(itemOne, itemTwo))
    }

    // MARK: Multiply Two Strings to Return Double Two Decimals

    /// Pass two string values to multiply and return the value as two decimal point double
    static func multiplyTwoItems2DecDoubleString(_ itemOne: String, _ itemTwo: String) -> String {
        String(format: "%.2f", itemOne.doubleValue * itemTwo.doubleValue)
    }

    // MARK: Multiply To Items to return as Full Double String Values

    /// Pass two string values to multiply and return the value as full double
    static func multiplyTwoItemsFullDoubleString(_ itemOne: String, _ itemTwo: String) -> String {
        String(format: "%f", itemOne.doubleValue * itemTwo.doubleValue)
    }

    // MARK: Add Two Strings as Integers

    /// Pass two string values to be added as integers and return the result as a string
    static func addTwoItemsAsIntegerString(_ itemOne: String, _ itemTwo: String) -> String {
        String(addTwoItemsAsInteger(itemOne, itemTwo))
    }

    // MARK: Add Two Strings as Double

    /// Pass two string values to be added as doubles and return the result as a string
    static func addTwoItemsAsDoubleString(_ itemOne: String, _ itemTwo: String) -> String {
        String(format: "%f", itemOne.doubleValue + itemTwo.doubleValue)
    }
}
