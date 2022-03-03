//
//  PLBaseViewViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

import UIKit

class PLBaseViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
    }
    
  
//    @available(iOS 12.0, *)
//    - (UIUserInterfaceStyle)overrideUserInterfaceStyle {
//
//        return UIUserInterfaceStyleLight;
//    }
//
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
}
