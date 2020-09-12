//
//  GridButton.swift
//  p4_Instagrid
//
//  Created by Cristian Rojas on 12/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit

class GridButton: UIButton {
    
    func setPicture(backgroundImage: UIImage?) {
        // Sets Aspect of the backgroundImage
        self.setImage(nil, for: .normal)
        self.setBackgroundImage(backgroundImage, for: .normal)
    }
}
