//
//  Board.swift
//  FourInARow
//
//  Created by Simon Italia on 4/23/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import UIKit
import GameplayKit

//enum to create and track chips in slots. Note! red assigned 1, black assigned 2 by iOS since we declared Int explicityly and 1st case = 0
enum Chip: Int {
    case none = 0
    case red
    case black
}

class GameBoard: NSObject, GKGameModel {
    
    //Mark: - GKGameModel Conformance methods and properties
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    //Create and return an empty Board object to setGameModel
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GameBoard()
        copy.setGameModel(copy)
        return copy
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        
        //Set the Game Model to the GameBaord class
        if let board = gameModel as? GameBoard {
            slots = board.slots
            currentPlayer = board.currentPlayer
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        //Optionally downcast GKGameModelPlayer as Player obejct
        if let playerObject = player as? Player {
            
            //If either player has won, signal to this method no moves are available by returning nil
            if isWin(for: playerObject) || isWin(for: playerObject.opponent) {
                
                return nil
            }
            
            //Else create new array to hold all Moves (move objects which are column numbers)
            var possibleMoves = [PossibleMove]()
        
            //Loop through all baord columns to determine wich (if any) can be used to make a player move
            for column in 0 ..< GameBoard.columns {
                if canMove(in: column) {
                    
                    //Appned Moves array with the column/s (Move object)that player can move to
                    possibleMoves.append(PossibleMove(column: column))
                }
            }
            
            //Return al possible moves array (list of column/s player can move to)
            return possibleMoves
        }
        
        return nil
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        
        //AI to apply / try all possible moves
        if let moveTo = gameModelUpdate as? PossibleMove {
            add(chip: currentPlayer.chip, in: moveTo.column)
            
            //Change players
            currentPlayer = currentPlayer.opponent
        }
    }
    
    //---
    
    //Current Player property
    var currentPlayer: Player
    
    //Set the size of the GameBoard
    static var columns = 7 //width
    static var rows = 6 //height
    
    //Create slots array to track all the slots on the b
    var slots = [Chip]()
    
    //Fill slots array with .none chipColor via a custom init method
    override init() {
        currentPlayer = Player.allPlayers[0]
        
        for _ in 0 ..< GameBoard.columns * GameBoard.rows {
            slots.append(.none)
        }
        
        super.init()
    }
    
    //Set chip color to a specific slot
    func set(chip: Chip, in column: Int, row: Int) {
        slots[row + column * GameBoard.rows] = chip
    }
    
    //Check which chip color (if any) occuipes each board slot
    func chip(inColumn column: Int, row: Int) -> Chip {
        return slots[row + column * GameBoard.rows]
    }
    
    //Helper method to determine if row in a specific column is free by moving up rows. (Will return first row no. if free, or nil if not)
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< GameBoard.rows {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    //Determine if user can move chip in a specific column by calling nextEmptySlot(in:) method and returning true or false
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    //Place chip in slot depending on result of emptySlot(in:) method
    func add(chip: Chip, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }
    
    //End of Game method, where players draw
    func isFull() -> Bool {
        
        //Check all columns to see if board is full or not
        for column in 0 ..< GameBoard.columns {
            if canMove(in: column) {
                return false
            }
        }
        
        return true
    }
    
    //End of Game method when a player wins
    func isWin(for player: GKGameModelPlayer) -> Bool {
        
        let chip = (player as! Player).chip
        
        for row in 0 ..< GameBoard.rows {
            for col in 0 ..< GameBoard.columns {
                if doSquaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 0) {
                        return true
                    
                } else if doSquaresMatch(initialChip: chip, row: row, col: col, moveX: 0, moveY: 1) {
                    return true
                
                } else if doSquaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 1) {
                        return true
                
                } else if doSquaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: -1) {
                    return true
                }
            }
        }
        
       return false
    }
    
    func doSquaresMatch(initialChip: Chip, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
        
        //If a win is not pssoible from here, exit method
        if row + (moveY * 3) < 0 { return false }
        if row + (moveY * 3) >= GameBoard.rows { return false }
        if col + (moveX * 3) < 0 { return false }
        if col + (moveX * 3) >= GameBoard.columns { return false}
        
        //Else check each sqaure for a win
        if chip(inColumn: col, row: row) != initialChip { return false }
        if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }

        return true
    }
    
    //Score method to inform the AI of the quality of a move
    func score(for player: GKGameModelPlayer) -> Int {
        
        //if current player wins, 
        if let playerObject = player as? Player {
            if isWin(for: playerObject) {
                return 1000
                
            } else if isWin(for: playerObject.opponent) {
                return -1000
            }
        }
        
        //If noone wins
        return 0
    }
    
    
    
}
