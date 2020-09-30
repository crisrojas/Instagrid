//
//  UIView.swift
//  p4_Instagrid
//
//  Created by Cristian Rojas on 12/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit

extension UIView {
    
    func asImage() -> UIImage? {
        
        UIGraphicsBeginImageContext(self.frame.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        self.layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        guard let cgImage = image.cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

