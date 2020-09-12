//
//  UIView.swift
//  p4_Instagrid
//
//  Created by Cristian Rojas on 12/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit

extension UIView {
    
    func asImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
        
    }
}

