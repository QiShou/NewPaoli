//
//  PLMeViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

import UIKit

class PLMeViewController: BaseTableViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            userIfon()
        }

    lazy var plView: PLMeHeader = {
        
       var v = PLMeHeader(frame: CGRect(x: 0, y: 10, width: ScreenWidth, height: 100), str: "")
        return v
    }()
    
    
//https://owner-test.itianding.com/#/collectionSign?projectId=1
    
        lazy var items :[CommonCellItemModel] = {
            
            var items :[CommonCellItemModel]
            
            let item5 = CommonCellItemModel.init(title: "托收签约",image: "", opration: { [weak self] in
                
                let dict = ["pd":"ios","projectId":AGUserDefaults().projectId ?? ""/*,"phone":AGUserDefaults().phone ?? ""*/]
                let str = URLPath().prarm(dict)
                let url = URL(string: HostType.type().webBaseUrl+URLPath().urlPathString.collectionSign+str)
                let com = ComonWebViewController(url: url!, title: "托收签约")
                com.isShowNav = true
                self?.navigationController?.pushViewController(com, animated: true)

            })
            
            
            let item4 = CommonCellItemModel.init(title: "预交费",image: "", opration: { [weak self] in
                
                let dict = ["pd":"ios"/*,"projectId":AGUserDefaults().projectId ?? "","phone":AGUserDefaults().phone ?? ""*/]
                let str = URLPath().prarm(dict)
                
                let url = URL(string: HostType.type().webBaseUrl+URLPath().urlPathString.preCharge+str)
                let com = ComonWebViewController(url: url!, title: "预交费")
                com.isShowNav = true
                self?.navigationController?.pushViewController(com, animated: true)

            })
            
            
            let item000 = CommonCellItemModel.init(title: "物业账单",image: "", opration: { [weak self] in
                
                let dict = ["pd":"ios","projectId":AGUserDefaults().projectId ?? "",/*"phone":AGUserDefaults().phone ?? ""*/]
                let str = URLPath().prarm(dict)
                
                let url = URL(string: HostType.type().webBaseUrl+URLPath().urlPathString.utilityBill+str)
                let com = ComonWebViewController(url: url!, title: "物业账单")
                com.isShowNav = true
                self?.navigationController?.pushViewController(com, animated: true)

            })
            
            let item00 = CommonCellItemModel.init(title: "业主认证",image: "", opration: { [weak self] in
                
                let dict = ["pd":"ios",/*"projectId":AGUserDefaults().projectId ?? "",*/"phone":AGUserDefaults().phone ?? ""]
                let str = URLPath().prarm(dict)
                
                let url = URL(string: HostType.type().webBaseUrl+URLPath().urlPathString.userApplyRecord+str)
                let com = ComonWebViewController(url: url!, title: "业主认证")
                com.isShowNav = true
                self?.navigationController?.pushViewController(com, animated: true)

            })
            
            let item0 = CommonCellItemModel.init(title: "服务记录",image: "", opration: { [weak self] in
                
                let dict = ["pd":"ios","projectId":AGUserDefaults().projectId ?? "","phone":AGUserDefaults().phone ?? ""]
                let str = URLPath().prarm(dict)
                
                let url = URL(string: HostType.type().webBaseUrl+URLPath().urlPathString.serviceOrder+str)
                let com = ComonWebViewController(url: url!, title: "服务记录")
                com.isShowNav = true
                self?.navigationController?.pushViewController(com, animated: true)

            })
            
            let item1 = CommonCellItemModel.init(title: "设置密码",image: "", opration: { [weak self] in
                
                let vc = PLSetPasswordViewController()
                self?.navigationController?.pushViewController(vc, animated: true)

            })
            let item2 = CommonCellItemModel.init(title: "修改密码",image: "", opration: { [weak self] in
                
                let vc = PLChangePasViewController()
                self?.navigationController?.pushViewController(vc, animated: true)

            })
            let item3 = CommonCellItemModel.init(title: "退出登录", image:"", opration: {
                                
                self.loginOut(account: "")
            })
 
            guard let hassetPassword = AGUserDefaults.hasSetPassord ,hassetPassword else {
                
                items = [item5,item4,item000,item00,item0,item2,item3]
                return items
            }
            items = [item5,item4,item000,item00,item0,item1,item3]

            return items
        }()

    }

    // MARK: - 设置UI
    extension PLMeViewController {
        
        func setupUI() {
            
            self.view.backgroundColor = UIColor.white
            self.title = "我的"
            tableView.bounces = false
            tableView.separatorColor = UIColor.init(hexString: "EEEEEE")
            tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
            tableView.rowHeight = 60
            let header = UIView()
            header.height = 140
            header.addSubview(self.plView)
            self.tableView.tableHeaderView = header
            self.tableView.reloadData()
        }
       
    }
    extension PLMeViewController {
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.items.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cellID = "cellID"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            if cell == nil {
                cell = UITableViewCell.init(style:.value1, reuseIdentifier: cellID)
                let item = items[indexPath.row]
                cell?.selectionStyle = .none
                cell?.textLabel?.text = item.title
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell?.textLabel?.textColor = UIColor.init(hexString: "2F2F2F")
                cell?.accessoryType = .disclosureIndicator
                cell?.detailTextLabel?.text = item.describe;
                cell?.detailTextLabel?.textColor = UIColor.init(hexString:"A9AFC2")
                
            }
            return cell!
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let item = items[indexPath.row]
            item.opration()
            
        }
    }

extension PLMeViewController {
    func userIfon()  {
        
        let api = UserAPI.personalProfile
        NetworkClient.default.sent(api, mType: PLUserInfo.self, networkHUD: .lockScreenButNavWithError) { res in
            switch res {
            
            case .responseObject(model: let model):
                print(model)
                self.plView.model = model
            case .requestFail,.responseFail:
                
                break
            default : break
            }
        }
    }
    
    func loginOut(account:String?)  {
        
        let accounts = AGUserDefaults().getUserDefaults(AGUserAccount) as? String
          guard accounts?.count ?? 0 > 0 else {
              SVProgressHUD.showError(withStatus: "账户为空")
              return
          }
        
        let api = UserAPI.loginOut(account: accounts!)
        NetworkClient.default.sent(api, mType: NullData.self, networkHUD: .lockScreenButNavWithError) { res in
            switch res {
            
            case .responseNoMap(data: let data):
                
                UIApplication.shared.keyWindow!.rootViewController = UINavigationController(rootViewController: PLLoginViewController())

                AGUserDefaults().setUserDefaults("", AGToken)
                
                break
            case .requestFail,.responseFail:
                
                break
            default : break
            }
        }
    }
}
