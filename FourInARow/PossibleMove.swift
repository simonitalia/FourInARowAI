//
//  Move.swift
//  FourInARow
//
//  Created by Simon Italia on 4/25/19.
//  Copyright © 2019 SDI Group Inc. All rights reserved.
//

//Class is responisble for the AI to be informed of the moves possible (column/s it can make a move in)
import GameplayKit
import UIKit

class PossibleMove: NSObject, GKGameModelUpdate {
    
    //Property to conform to GKGameModelUpdate
    var value: Int = 0
    
    var column: Int
    
    init(column: Int) {
        self.column = column
    }

}
