//
//  Player.swift
//  FourInARow
//
//  Created by Simon Italia on 4/24/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

import UIKit
import GameplayKit

class Player: NSObject, GKGameModelPlayer {
    
    //Property provided by GameplayKit
    var playerId: Int
    
    var chip: Chip
    var color: UIColor
    var name: String
        
    static var allPlayers = [Player(chip: .red), Player(chip: .black)]

    init(chip: Chip) {
        self.chip = chip
        self.playerId = chip.rawValue
        
        if chip == .red {
            
            color = .red
            name = "PLAYER ONE (RED)"
        
        } else {
            color = .black
            name = "AI (BLACK)"
        }
        
        super.init()
    }
    
    //Return a player's opponent method
    var opponent: Player {
        if chip == .red {
            return Player.allPlayers[1]
        
        } else {
            return Player.allPlayers[0]
        }
    }
    
}
