//
//  PLHomeViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

import UIKit

class PLHomeViewController: PLBaseViewViewController {

    
    var datArr:[PBUserRoleModule]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "首页"
        self.view.backgroundColor = .white
        swtUI()
        registCell()
        self.switchTM(account: "")
        
    }
    
    func swtUI(){
        self.view.addSubview(self.tableView)
    }
    
    lazy var tableView : UITableView = {
       
        let v = UITableView.init(frame: self.view.bounds, style: .plain)
        
        v.backgroundColor = .white
        v.dataSource = self
        v.delegate = self
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.estimatedRowHeight = 80
        
        return v
        
    }()
    
}


extension PLHomeViewController {
    
    func switchTM(account:String?) {
        
      let accounts = AGUserDefaults().getUserDefaults(AGUserAccount) as? String
        guard accounts?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "账户为空")
            return
        }
        
        let api = UserAPI.switchTenantMenu(account: accounts!)
        NetworkClient.default.sent(api, mType: CommonListRes<PBUserRoleModule>.self, networkHUD: .lockScreenButNavWithError) { res in
            switch res {
            
            case .responseObject(model: let model):
                print(model)
           
                self.datArr = model.tabMenu?.filter({ $0.code == "HOME_PAGE"})
                let tempArr = self.datArr?.first?.children
                
                self.datArr = tempArr?.filter({ $0.code == "TOP_MENU"})
                self.tableView.reloadData()
            case .requestFail,.responseFail:
                
                break
            default : break
            }
            
        }
        
    }
    
    
}


extension PLHomeViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func registCell()  {
        
        self.tableView.register(PLSWorkOderTableViewCell.classForCoder(), forCellReuseIdentifier: "PLSWorkOderTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PLSWorkOderTableViewCell", for: indexPath) as? PLSWorkOderTableViewCell
        
        cell?.setUpUI(arr: datArr?.first?.children, info: PLUserInfo(), text: datArr?.first?.name ?? "功能菜单")
        cell?.block = {  model in
            
            if model.code == "REPAIR" {
                
                if  !(model.path?.contains("http"))! {
                    return
                }
                
                let urlstr = "\(model.path ?? "")?pd=ios"
                
                let  url = URL(string:urlstr)
                
                let com = ComonWebViewController(url: url!, title: "报事报修")
                com.isShowNav = true
                self.navigationController?.pushViewController(com, animated: true)
                
            } else {
                SVProgressHUD.showError(withStatus: "正在努力开发中")
            }
            
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
   
}


