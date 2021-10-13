//
//  PLRootController.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

import UIKit

class PLRootController: UITabBarController {

    var arr : [PBUserRoleModule]?
    
    
    init(arr:[PBUserRoleModule]?) {
        super.init(nibName: nil, bundle: nil)
    
        self.addChildCon(PLHomeViewController(), "首页", "ic_index_unselect", "ic_index_select")
        self.addChildCon(PLMeViewController(), "我的", "ic_mine_unselect", "ic_mine_select")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initThemes()
      
    }
    
    private func addChildCon(_ con:PLBaseViewViewController,_ title:String? , _ imageName: String , _ seletedImgName:String)  {
        
        con.tabBarItem.title = title
        con.tabBarItem.image = UIImage(named: imageName)
        con.tabBarItem.selectedImage = UIImage(named: seletedImgName)
        self.addChild(PLNavViewController.init(rootViewController: con))
    }
    
    private func initThemes() {
        tabBar.isTranslucent = false

        tabBar.shadowImage = UIImage()
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.5, green: 0.5, blue: 0.6, alpha: 1),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .highlighted)
        
      
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
