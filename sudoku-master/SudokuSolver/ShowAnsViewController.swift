//
//  ShowAnsViewController.swift
//  SudokuSolver
//
//  Created by itst on 2/1/2021.
//

import UIKit

class ShowAnsViewController: UIViewController ,SudokuDelegate {
    
    var sudoku = Sudoku()
    @IBOutlet weak var SudokuContainer: UIStackView!
    var textFields = [[UITextField]]() 

    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField()  //Will sir
        sudoku.delegate = self
        
        if(sudoku.showAnsSodoku(textFields: textFields)) {
            for row in 0..<9 {
                for column in 0..<9 {
                    textFields[row][column].text = "\(sudoku.cells[row][column].value)"
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func sudokuUpdate(cells: [[SudokuCell]]) {
        for row in 0..<9 {
            for column in 0..<9 {
                textFields[row][column].text = cells.isEmpty ? "" : "\(cells[row][column].value)"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
