//
//  Sudoku.swift
//  SudokuSolver
//
//  Created by itst on 30/12/2020.
//

import Foundation
import UIKit

protocol  SudokuDelegate {
    func sudokuUpdate(cells : [[SudokuCell]])
}

struct SudokuCell {    //Will sir
    var value = 0
    var isQuestion = false
    var isEmpty : Bool {
        return (value == 0)
    }
}

struct SudokuCursor {  //Will sir
    var row = 0
    var column = 0
    var direction = 1 //1 is forward, -1 backward
    mutating func move(){
        if direction == 1 {
            //move forward
            if row == 8 && column == 8 {
                return
            }
            column = column + 1
            if column > 8 {
                column = 0
                row = row + 1
            }
        } else {
            //move back ward
            if row == 0 && column == 0 {
                return
            }
            column = column - 1
            if column < 0 {
                column = 8
                row = row - 1
            }
        }
    }
}

class Sudoku {          //Will sir
    var cells : [[SudokuCell]]
    var delegate : SudokuDelegate?
    var timer : Timer?
    init() {
        cells = [[SudokuCell]]()
        resetSudoku()
    }
    
    func resetSudoku() {  //Will sir
        for _ in 0..<9 {
            var row = [SudokuCell]()
            for _ in 0..<9 {
                row.append(SudokuCell())
            }
            cells.append(row)
        }
    }
    
    
    
    func startSovingSodoku(textFields :[[UITextField]]) -> Bool {     //Will sir
        //setp 1 -reset
        resetSudoku()
        //setp 2 - copy question
        copySudoku(textField: textFields)
        printSudoku()
        //setp 3 - validate question
        if validata() == false {
            return false
        }
    
        
        //setp 4 - solve
//        solve()
    if timer != nil {     //animation
        timer?.invalidate()
        timer = nil
    }

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: {
            t in
            if self.cursor.column == 8 && self.cursor.row == 8 {
                self.solve()
                //stop the timer
                t.invalidate()
                self.timer = nil
            } else {
//                self.cells[self.cursor.row][self.cursor.column].value = 2
//                self.delegate?.sudokuUpdate(cells: self.cells)
//                self.cursor.move()
                    let cell = self.cells[self.cursor.row][self.cursor.column]
                    //如果呢個題目 （預先輸入）
                    if cell.isQuestion {
                        //就跳前多一格 /或退後多一格，睇個方向決定
                        //move forward or move back
                        self.delegate?.sudokuUpdate(cells: self.cells)
                        self.cursor.move()
                    } else {
                        //如果唔係題目
                        let start = cell.value + 1
                        if start > 9 {
                            //因為去到 9 都 fill 唔到，返轉頭 ＋ 清空呢格
                            self.cells[self.cursor.row][self.cursor.column] = SudokuCell(value: 0, isQuestion: false)
                            //move backword
                            self.cursor.direction = -1
                        } else {
                            for value in start...9 {
                                if self.checkRow(self.cursor, valueToCheck: value) && self.checkColumn(self.cursor, valueToCheck: value) && self.check3x3(self.cursor, valurToCheck: value){
                                    self.cells[self.cursor.row][self.cursor.column] = SudokuCell(value: value, isQuestion: false)
                                    //move forward
                                    self.cursor.direction = 1
                                    break
                                } else {
                                    //因為去到 9 都 fill 唔到，返轉頭 ＋ 清空呢格
                                    self.cells[self.cursor.row][self.cursor.column] = SudokuCell(value: 0, isQuestion: false)
                                    //move backward
                                    self.cursor.direction = -1
                                }
                            }
                        }
                        self.delegate?.sudokuUpdate(cells: self.cells)
                        self.cursor.move()
                    }
            }})
        
            return true

        }
    
    func showAnsSodoku(textFields :[[UITextField]]) -> Bool { 
        //setp 1 -reset
        resetSudoku()
        //setp 2 - copy question
        copySudoku(textField: textFields)
        printSudoku()
        //setp 3 - validate question
        if validata() == false {
            return false
        }
        //setp 4 - solve
        solve()
        
        return true

        }
  
    
    var cursor = SudokuCursor()
    func solve(){  //Will sir
        //如果個題目未解決就 while 不斷 loop
        while (!solved()) {
            let cell = cells[cursor.row][cursor.column]
            //如果呢個題目 （預先輸入）
            if cell.isQuestion {
                //就跳前多一格 /或退後多一格，睇個方向決定
                //move forward or move back
                cursor.move()
            } else {
                //如果唔係題目
                let start = cell.value + 1
                if start > 9 {
                    //因為去到 9 都 fill 唔到，返轉頭 ＋ 清空呢格
                    cells[cursor.row][cursor.column] = SudokuCell(value: 0, isQuestion: false)
                    //move backword
                    cursor.direction = -1
                } else {
                    for value in start...9 {
                        if checkRow(cursor, valueToCheck: value) && checkColumn(cursor, valueToCheck: value) && check3x3(cursor, valurToCheck: value){
                            cells[cursor.row][cursor.column] = SudokuCell(value: value, isQuestion: false)
                            //move forward
                            cursor.direction = 1
                            break
                        } else {
                            //因為去到 9 都 fill 唔到，返轉頭 ＋ 清空呢格
                            cells[cursor.row][cursor.column] = SudokuCell(value: 0, isQuestion: false)
                            //move backward
                            cursor.direction = -1
                        }
                    }
                }
                cursor.move()
            }
            delegate?.sudokuUpdate(cells: cells)
            printSudoku()
        }
    }

    func solved() -> Bool {  //Will sir
        for x in 0...8 {
            for y in 0...8 {
                if cells[x][y].isEmpty {
                   return false
                }
            }
        }
        return true
    }
    
    func copySudoku(textField : [[UITextField]]) {      //Will sir
        for row in 0..<9 {
            for column in 0..<9 {
                let value = Int(textField[row][column].text!) ?? 0
                if value > 0 && value < 10 {
                    cells[row][column] = SudokuCell(value: value, isQuestion: true)
                } else {
                    cells[row][column] = SudokuCell()
                }
            }
        }
    }
    
    func validata() -> Bool {    //Will sir
        for row in 0..<9 {
            for column in 0..<9 {
                if !cells[row][column].isEmpty {
                    let cursor = SudokuCursor(row: row, column: column)
                    let value = cells[row][column].value
                    if checkRow(cursor, valueToCheck: value) == false || checkColumn(cursor, valueToCheck: value)  == false || check3x3(cursor, valurToCheck: value) == false {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func checkColumn(_ cursor : SudokuCursor,valueToCheck : Int) -> Bool {  //Will sir
        let cursorRow = cursor.row
        let cursorColumn = cursor.column
        for row in 0..<9 {
            if  cells[row][cursorColumn].value == valueToCheck && cursorRow != row {
                return false
            }
        }
        return true
    }
    
    func checkRow(_ cursor : SudokuCursor,valueToCheck : Int) -> Bool {  //Will sir
        let cursorRow = cursor.row
        let cursorColumn = cursor.column
        for column in 0..<9 {
            if  cells[cursorRow][column].value == valueToCheck && cursorColumn != column {
                return false
            }
        }
        return true
    }
    
    func check3x3(_ cursor : SudokuCursor, valurToCheck : Int) -> Bool {  //Will sir
        let cursorRow = cursor.row
        let cursorColumn = cursor.column
        let rowOffset = get3x3Offset(pos: cursorRow)
        let columnOffset = get3x3Offset(pos: cursorColumn)
        for row in (0 + rowOffset)...(2 + rowOffset) {
            for column in (0 + columnOffset)...(2 + columnOffset) {
                if cells[row][column].value == valurToCheck && cursorRow != row && cursorColumn != column {
                    return false
                }
            }
        }
        return true
    }
    
    func get3x3Offset(pos : Int) -> Int {  //Will sir
        switch(pos) {
        case 0...2: return 0
        case 3...5: return 3
        default: return 6
        }
    }
    
    func  printSudoku(){  //Will sir
        var text = ""
        for row in 0..<9 {
            for column in 0..<9 {
                text = "\(text) \(cells[row][column].value)"
            }
            text = "\(text) \n"
        }
        print(text)
    }
}

