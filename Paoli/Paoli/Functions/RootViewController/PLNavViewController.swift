//
//  PLNavViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

import UIKit

class PLNavViewController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = children.count > 0
        super.pushViewController(viewController, animated: animated)
    }
    

}
