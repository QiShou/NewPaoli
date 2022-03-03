//
//  PLHomeViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

import UIKit
import SVProgressHUD

class PLHomeViewController: PLBaseViewViewController {

    
    var datArr:[PBUserRoleModule]?
    var projectArr:[PLProjectListModel]? {
        
        didSet {
            
            guard projectArr?.count ?? 0 > 0 && projectArr?.count == 1 else {
                
                let model = projectArr?.first
                self.setfbtnText(model?.name ?? "田丁","\(model?.id ?? 0)" )
                
                return
            }
            
            let model = projectArr?.first
            self.setfbtnText(model?.name ?? "田丁","\(model?.id ?? 0)" )
            self.fBtn.setImage(.init(named: "home_icon_switch_triangle"), for: .normal)
        }
        
    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.title = "首页"
        self.view.backgroundColor = .white
        swtUI()
        registCell()
        self.switchTM(account: "")
        listByCurrentOwner()
        
    }
    
    func swtUI(){
        nav()
        self.view.addSubview(self.tableView)
    }
    
    func nav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.fBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(named: "home_ic_scan"), style: .plain, target: self, action: #selector(rightAction))
    }
    
    @objc func rightAction()  {
        
    }
    @objc func tapped(_ sneder:UIButton){
        
    }
    
    lazy var tableView : UITableView = {
       
        let v = UITableView.init(frame: self.view.bounds, style: .plain)
        v.backgroundColor = .white
        v.dataSource = self
        v.delegate = self
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.estimatedRowHeight = 80
        v.tableHeaderView = headerView
        return v
    }()
    
    lazy var img : UIImageView = {
       let imgs = UIImageView(frame: CGRect(x: 16, y: 14, width: ScreenWidth-32, height: 150))
        imgs.image = UIImage(named: "home_banner")
        
        return imgs
    }()
    
    lazy var headerView : UIView = {
       
        let v = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 170))
        v.backgroundColor = .white
        v.addSubview(img)
        return v
    }()
    
    lazy var fBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom);//新建btn
        btn.frame = CGRect.init(x: 10, y: 0, width: 150, height: 45);
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true //设置圆角
        btn.setTitle("田丁", for: .normal)//设置标题
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)//设置字体大小
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        btn.addTarget(self, action:#selector(tapped(_:)), for:UIControl.Event.touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        return btn
        
    }()
     
    func setfbtnText(_ text:String , _ projectId:String) {
        fBtn.setTitle(text, for: .normal)
        
        AGUserDefaults().setUserDefaults(projectId, AGProjectId)
        
        self.switchTenant(projectId)
        
    }
    
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
    
    
    func listByCurrentOwner()  {
        
        let api = UserAPI.listByCurrentOwner(cityCodes: "", companyId: "", masterOrgId: "", name: "")
        NetworkClient.default.sent(api, mType: PLProjectListModel.self, networkHUD: .background) { res in
            
            switch res {
            case .requestFail: break
                
            case .responseArray(dataArr: let dataArr):
                print(dataArr)
                
                if dataArr.count > 0 {
                    self.projectArr = dataArr;
                } else {
                    SVProgressHUD.show(UIImage(), status: "小区列表为空")
                }
                break
           
            case .responseFail(errcode: _, msg: let msg):
                SVProgressHUD.showError(withStatus: msg)
                break
            default:break
                
            }
        }
        
    }
    
    func switchTenant (_ projectId: String) {
        
        let api = UserAPI.switchTenant(projetId: projectId)
        NetworkClient.default.sent(api, mType: NullData.self, networkHUD: .background) { res in
            
            switch res {
            case .responseNoMap(data: let data):
                
                guard let dict = data.rawValue as? [String:Any] else {
                    return
                }
                self.saveToken(dict)
                break
            case .responseFail,.requestFail:
                break
            default:break
                
            }
        }
        
    }
    
    func saveToken(_ dict:Dictionary<String, Any>)  {
        
        AGUserDefaults().setUserDefaults("bearer \(dict["token"] ?? "")", AGToken)
        
    }
}


extension PLHomeViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func registCell()  {
        
        self.tableView.register(PLSWorkOderTableViewCell.classForCoder(), forCellReuseIdentifier: "PLSWorkOderTableViewCell")
        self.tableView.register(PLHomeNoticeCell.classForCoder(), forCellReuseIdentifier: "PLHomeNoticeCell")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
           do {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PLHomeNoticeCell", for: indexPath) as? PLHomeNoticeCell
                
                
                return cell!;
                
            }
          
        case 1:do {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PLSWorkOderTableViewCell", for: indexPath) as? PLSWorkOderTableViewCell
            
            cell?.setUpUI(arr: self.datArr?.first?.children, info: PLUserInfo(), text: datArr?.first?.name ?? "功能菜单")
            cell?.block = {  model in
                
                if model.code == "REPAIR" {
                    
                    if  !(model.path?.contains("http"))! {
                        return
                    }
                    
                    let urlstr = "\(model.path ?? "")?pd=ios&projectId=\(AGUserDefaults().projectId ?? "")"
                    
                    guard  let  url = URL(string:urlstr),url != nil else {
                        SVProgressHUD.showError(withStatus: "网址为空")
                        return
                    }
                    
                    let com = ComonWebViewController(url: url , title: "报事报修")
                    com.isShowNav = true
                    self.navigationController?.pushViewController(com, animated: true)
                    
                } else {
                    SVProgressHUD.showError(withStatus: "正在努力开发中")
                }
                
            }
            return cell!
        }
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
            return cell;
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 84
            
        } else {
            
            return 209
        }
        
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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


