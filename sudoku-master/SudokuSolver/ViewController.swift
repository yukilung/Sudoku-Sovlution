//
//  ViewController.swift
//  SudokuSolver
//
//  Created by itst on 30/12/2020.
//

import UIKit

class ViewController: UIViewController ,SudokuDelegate {
    var sudoku = Sudoku()
    @IBOutlet weak var SudokuContainer: UIStackView!
    var textFields = [[UITextField]]() //Will sir
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        linkTextField()  //Will sir
        sudoku.delegate = self
    }
    
    @IBAction func solveClicked(_ sender: Any) {  //Will sir
        if(sudoku.startSovingSodoku(textFields: textFields)) {
            
        } else {
            print("invalid question")
        }
    }
    
    func sudokuUpdate(cells: [[SudokuCell]]) {
        for row in 0..<9 {
            for column in 0..<9 {
                textFields[row][column].text = cells.isEmpty ? "" : "\(cells[row][column].value)"
            }
        }
    }
    
    @IBAction func resetClicked(_ sender: Any) {  //Will sir
        for tfRow in textFields {
            for tf in tfRow {
                tf.text = ""
            }
        }
    }
    func linkTextField(){          //Will sir
        for row in 11...19 {
            let rowContiner = SudokuContainer.viewWithTag(row)
            var textFieldRow = [UITextField]()
            for column in 1...9 {
                let textField = rowContiner?.viewWithTag(column) as! UITextField
                textFieldRow.append(textField)
            }
            textFields.append(textFieldRow)
        }
    }
    
}

