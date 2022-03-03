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
    
        let str = URLPath().prarm(["pd":"ios"])
        let homeUrl = URL(string: HostType.type().webBaseUrl+URLPath().urlPathString.home+str)
        let homeWebCon = ComonWebViewController(url: homeUrl!, title: "")
        self.addChildCon(homeWebCon, "首页", "ic_index_unselect", "ic_index_select")

        let myUrl = URL(string: HostType.type().webBaseUrl+URLPath().urlPathString.my+str)
        let myWebCon = ComonWebViewController(url: myUrl!, title: "")
        
//        self.addChildCon(PLHomeViewController(), "首页", "ic_index_unselect", "ic_index_select")
        self.addChildCon(PLGoodViewController(), "商城", "ic_mine_unselect", "ic_mine_select")
        self.addChildCon(PLPpenDoorViewController(), "开门", "ic_index_unselect", "ic_index_select")
//        self.addChildCon(PLMeViewController(), "我的", "ic_mine_unselect", "ic_mine_select")
        self.addChildCon(myWebCon, "我的", "ic_mine_unselect", "ic_mine_select")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

//        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .white
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.5, green: 0.5, blue: 0.6, alpha: 1),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ], for: .highlighted)
        
      
    }

}
