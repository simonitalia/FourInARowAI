//
//  ViewController.swift
//  FourInARow
//
//  Created by Simon Italia on 4/23/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Track all the placedChips on the board
    var placedChips = [[UIView]]()
    
    var board: GameBoard!
    
    //Button Outltet array property
    @IBOutlet var columnButtons: [UIButton]!
    
    //Button Actions array property
    @IBAction func makeMove(_ sender: UIButton) {
        
        let column = sender.tag
        if let row = board.nextEmptySlot(in: column) {
            
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            continueGame()            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Setup new Game Board. Clear out all placedChips
        for _ in 0 ..< GameBoard.columns {
            placedChips.append([UIView]())
        }
        
        resetGameBoard()
    }
    
    func resetGameBoard() {
        board = GameBoard()
        updateUI()
        
        //Loop through placedChips array and remove each chip (UIView)
        
        //Loop for .count (7) times, starting at 0 and ending at 6
        for i in 0 ..< placedChips.count {
            
            //What do on each loop (remove chip object / UIView at index)
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
        placedChips[i].removeAll(keepingCapacity: true)
        
        }
    }
    
    //Method that places chip in an (allowed) slot with animation, color etc (this matches GameBoard class's add(chip: in) method.) Called when user taps on a slot
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        //Create chip, animate and enure move into row is safe
        if (placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            placedChips[column].append(newChip)
        }
    }
    
    //Method to calculate the position of a chip placement
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        
        //Pull out the UIButton that represents the correct column
        let button = columnButtons[column]
        
        //Set chip size to either column button width or column button height / 6, whichever is lowest
        let size = min(button.frame.width, button.frame.height / 6)
        
        //Get horizontal X center of column button with midX,
        let xOffset = button.frame.midX
        
        //Get bottom of column button with maxY, then divid by 2 to get the center of chip
        var yOffset = button.frame.maxY - size / 2
        
        //Multiply row by size of each chip to determine Y offset
        yOffset -= size * CGFloat(row)
        
        //Return results
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
        
    }
    
    //Switch player or End Game
    func continueGame() {
        
        //Create gameOverTitle to set when game ends
        var gameOverTitle: String? = nil
        
        //When Game ends, set gameOverTitle depending on win or draw
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
            
        } else if board.isFull() {
            gameOverTitle = "It's a Draw!"
        }
        
        //Show alert to user in event of Game Over
        if gameOverTitle != nil {
            let ac = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Play Again?", style: .default) { [unowned self] (action) in
                self.resetGameBoard()
            }
            
            ac.addAction(alertAction)
            present(ac, animated: true)
            
            return
        }
        
        //If game not over, change player
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
        
    }
    
    
}

