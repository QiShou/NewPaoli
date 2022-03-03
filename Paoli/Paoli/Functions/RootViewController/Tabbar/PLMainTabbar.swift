//
//  PLMainTabbar.swift
//  Paoli
//
//  Created by 0 on 2021/12/21.
//

import UIKit

class PLMainTabbar: UIView {

 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: ScreenWidth/2, y: 0))
       
        
        
    }
  

    
    
   
}
