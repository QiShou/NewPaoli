//
//  PLLoginViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/23.
//

import UIKit


enum LoginType {
    case password
    case msgCode
}

class PLLoginViewController: PLBaseViewViewController {
    var loginType = LoginType.password

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "登录"
        setUI()
        
        
        
    }
    
    
    @objc func tapped(_ sender: UIButton){
        if sender.tag == 100 {
            print("login")
            switch self.loginType {
            case .password:
                
                login(accout: self.accountFd.text, password: self.passwordFd.text)
            case .msgCode:
                loginMsg(mobile: self.accountFd.text, smsCode: self.passwordFd.text)
            default:
                break
            }
            
        } else if sender.tag == 101 {
            print("as'd's'f")
            
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                self.loginType = .msgCode
                
                self.downBtn.isHidden = false
                self.passwordFd.placeholder = "请输入验证码"
                self.passwordFd.text = nil
                self.passwordFd.isSecureTextEntry = true
                loginBtn.setTitle("验证码登录", for:.normal)
                self.passwordFd.keyboardType = .numberPad
                
            } else {
                self.loginType = .password
                self.passwordFd.keyboardType = .default
                self.passwordFd.text = nil
                self.passwordFd.isSecureTextEntry = false
                self.passwordFd.placeholder = "请输入密码"
                loginBtn.setTitle("密码登录", for:.normal)
                self.downBtn.isHidden = true
            }
            
        } else {
            let con = PLFPaswordViewController()
            con.accountFdStr = self.accountFd.text ?? ""
            self.navigationController?.pushViewController(con, animated: true)
        }
        
    }
    
    
    @objc func sendVerfilyCode() {
        
        self.sendCodeMsg(mobile: self.accountFd.text ?? "", type: "LOGIN")
    }
    
    func setUI()  {
        self.view.addSubview(self.accountFd)
        self.view.addSubview(self.passwordFd)
        self.view.addSubview(self.fBtn)
        self.view.addSubview(self.vBtn)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.downBtn)

    }
    

    var downBtn = { () -> CountdownButton in
        
        let dowBtn = CountdownButton(frame: .zero, callback: { btn, state, count in
            switch state {
                
                case .normal:
                    btn.setTitle("获取验证码", for: .normal)
                    btn.setTitleColor(CommonAppearance.mainBtnColor, for: .normal)
                    
                case .countdown:
                    btn.setTitle("\(count)秒", for: .normal)
                    btn.setTitleColor(CommonAppearance.mainBtnColor, for: .normal)
                    
                case .reget:
                    btn.setTitle("重新获取", for: .normal)
                    btn.setTitleColor(CommonAppearance.mainBtnColor, for: .normal)
            }
        })
//        dowBtn.setTitleColor(UIColor.init(hexString: "#6B75FF"), for: .normal)
        dowBtn.frame = CGRect(x:ScreenWidth-120, y:170, width:120, height:45)
        dowBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        dowBtn.addTarget(self, action: #selector(sendVerfilyCode), for: .touchUpInside)
        dowBtn.isHidden = true
        return dowBtn
    }()
    
    lazy var fBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom);//新建btn
        btn.frame = CGRect.init(x: ScreenWidth-120, y: 275, width: 100, height: 45);
        //frame位置和大小
        //             btn.backgroundColor = CommonAppearance.mainBtnColor;//背景色
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true //设置圆角
        btn.setTitle("忘记密码", for: .normal)//设置标题
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)//设置字体大小
        btn.tag = 102
        btn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)

        btn.addTarget(self, action:#selector(tapped(_:)), for:UIControl.Event.touchUpInside)
        return btn
        
    }()
    
    lazy var vBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom);//新建btn
        btn.frame = CGRect.init(x: 20, y: 275, width: 100, height: 45);//frame位置和大小
        //             btn.backgroundColor = CommonAppearance.mainBtnColor;//背景色
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true //设置圆角
        btn.setTitle("验证码登录", for:  .normal)//设置标题
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)//设置字体大小
        btn.tag = 101
        btn.addTarget(self, action:#selector(tapped(_:)), for:UIControl.Event.touchUpInside)
        btn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)

        return btn
        
    }()
    
    lazy var loginBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom);//新建btn
        btn.frame = CGRect.init(x: 20, y: 230, width: ScreenWidth-40, height: 45);//frame位置和大小
        btn.backgroundColor = CommonAppearance.mainBtnColor;//背景色
        btn.setTitleColor(UIColor(hexString: "#ffffff"), for: .normal)
        btn.tag = 100
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true //设置圆角
        btn.setTitle("登录", for:  UIControl.State.normal)//设置标题
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)//设置字体大小
        
        btn.addTarget(self, action:#selector(tapped(_:)), for:UIControl.Event.touchUpInside)
        
        return btn
        
    }()

    lazy var passwordFd : UITextField = {
       
        let textField = UITextField(frame: CGRect(x:20, y:170, width:ScreenWidth-40, height:45))
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "请输入登录密码"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.text = "123456"

        return textField;
    }()
    
    lazy var accountFd : UITextField = {
       
        let textField = UITextField(frame: CGRect(x:20, y:120, width:ScreenWidth-40, height:45))
        textField.text = "17688937355"
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.clearButtonMode = .unlessEditing  //编辑时不出现，编辑后才出现清除按钮
        textField.placeholder = "请输入登录账户"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.returnKeyType = UIReturnKeyType.next //表示继续下一步
        textField.keyboardType = .phonePad
        textField.backgroundColor = .white
        return textField;
    }()
   
}


extension PLLoginViewController {
    
    
    
    func saveToken(_ dict:Dictionary<String, Any>)  {
        
        AGUserDefaults().setUserDefaults("bearer \(dict["token"] ?? "")", AGToken)
        
    }
    
    func login(accout:String?,password:String?) {
        
        guard accout?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入账号")
            return
        }
        guard password?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入密码")
            return
        }
        
        
        let api = UserAPI.login(account: accout! , password: password!.md5)
        NetworkClient.default.sent(api, mType: NullData.self, networkHUD: .lockScreenButNavWithError) { res in
            
            switch res {
            case .responseNoMap(data: let data):
                print(data)
                guard let dict = data.rawValue as? [String:Any] else {
                    return
                }
                self.saveToken(dict)
                AGUserDefaults().setUserDefaults(accout, AGAccount)
                AGUserDefaults().setUserDefaults(password, AGPassword)
                AGUserDefaults().setUserDefaults("\(dict["account"] ?? "")", AGUserAccount)
                self.switchTM(account: "\(dict["account"] ?? "")")

                
//                guard let arr = dict["tenants"] as? [Dictionary<String,Any>] , arr.count > 0 else {
//
//                    SVProgressHUD.showError(withStatus: "平台权限为空")
//                    return
//                }
                break
           
            default : break
            }
            
        }
        
    }
    
    func loginMsg(mobile:String?,smsCode:String?)  {
        guard mobile?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入手机号")
            return
        }
        guard smsCode?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入验证码")
            return
        }
        
        let api = UserAPI.laginMsg(mobile: mobile!, smsCode: smsCode!)
        NetworkClient.default.sent(api, mType: NullData.self, networkHUD: .lockScreenButNavWithError) { res in
            switch res {
            case .responseNoMap(data: let data):
                print(data)
                guard let dict = data.rawValue as? [String:Any] else {
                    SVProgressHUD.showError(withStatus: "数据为空")
                    return
                }
                self.saveToken(dict)
                AGUserDefaults().setUserDefaults("\(dict["account"] ?? "")", AGUserAccount)
                self.switchTM(account: "\(dict["account"] ?? "")")
            default : break
            }
        }
        
    }
    

    
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
               
                UIApplication.shared.keyWindow!.rootViewController = PLRootController(arr: model.tabMenu)

            case .requestFail,.responseFail:
                break
            default :
                break;
            }
            
           
        }
        
    }
    
    func sendCodeMsg(mobile:String?,type:String?) {
        
        guard mobile?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入手机号")
            
            return
        }
        guard type?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "验证码类型为空")
            return
        }
        
        downBtn.start()
        let request = UserAPI.sendMsgCode(mobile: self.accountFd.text!, type:"LOGIN")
        NetworkClient.default.sent(request, mType:NullData.self, networkHUD: .lockScreenAndError) { (res) in
            switch res {
            case .requestFail,.responseFail:
                self.downBtn.stop()
            default :
                break
            }
        }

    }
    
}
