//
//  PLMsgLoginViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/28.
//

import UIKit

class PLFPaswordViewController: PLBaseViewViewController {
    var accountFdStr : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "忘记密码"
        setUI()
    }
    
    func setUI()  {
        self.view.addSubview(self.accountFd)
        self.view.addSubview(self.passwordFd)
        self.view.addSubview(self.mesgCodeFd)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.downBtn)
        

    }
    @objc func tapped(_ sender: UIButton){
        if sender.tag == 100 {
//            loginMsg(mobile: self.accountFd.text, smsCode: self.passwordFd.text)
            findPwd(mobile: self.accountFd.text, smsCode: "\(self.mesgCodeFd.text ?? "")", password: self.passwordFd.text)
        }
        
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
        dowBtn.frame = CGRect(x:ScreenWidth-120, y:175, width:120, height:45)
        dowBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        dowBtn.addTarget(self, action: #selector(sendVerfilyCode), for: .touchUpInside)
        
        return dowBtn
    }()
    
    @objc func sendVerfilyCode() {
        
        self.sendCodeMsg(mobile: self.accountFd.text ?? "", type: "RECOVER_PWD")
    }
    
    
    lazy var loginBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom);//新建btn
        btn.frame = CGRect.init(x: 20, y: 290, width: ScreenWidth-40, height: 45);//frame位置和大小
        btn.backgroundColor = CommonAppearance.mainBtnColor;//背景色
        btn.setTitleColor(UIColor(hexString: "#ffffff"), for: .normal)
        btn.tag = 100
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true //设置圆角
        btn.setTitle("确认密码", for:  UIControl.State.normal)//设置标题
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)//设置字体大小
        
        btn.addTarget(self, action:#selector(tapped(_:)), for:UIControl.Event.touchUpInside)
        
        return btn
        
    }()
    lazy var passwordFd : UITextField = {
       
        let textField = UITextField(frame: CGRect(x:20, y:230, width:ScreenWidth-40, height:45))
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "请输入新密码"
        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.text = "123456"

        return textField;
    }()
    lazy var mesgCodeFd : UITextField = {
       
        let textField = UITextField(frame: CGRect(x:20, y:175, width:ScreenWidth-40, height:45))
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "请输入验证码"
        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.text = "123456"

        return textField;
    }()
    
    lazy var accountFd : UITextField = {
       
        let textField = UITextField(frame: CGRect(x:20, y:120, width:ScreenWidth-40, height:45))
//        textField.text = "17688937355"
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


extension PLFPaswordViewController {
    
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
        let request = UserAPI.sendMsgCode(mobile: self.accountFd.text!, type:"RECOVER_PWD")
        NetworkClient.default.sent(request, mType:NullData.self, networkHUD: .lockScreenAndError) { (res) in
            switch res {
            case .requestFail,.responseFail:
                self.downBtn.stop()
            default :
                break
            }
        }

    }
    func findPwd(mobile:String?,smsCode:String?,password:String?) {
        
        guard mobile?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入手机号")
            return
        }
        guard smsCode?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入验证码")
            return
        }
        guard password?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入新密码")
            return
        }
        
        let request = UserAPI.forgetPwd(mobile: mobile ?? "", password: password?.md5 ?? "", repeatPassword: password?.md5 ?? "", smsCode: smsCode ?? "")
        NetworkClient.default.sent(request, mType:NullData.self, networkHUD: .lockScreenAndError) { (res) in
            switch res {
            
            case .responseNoMap(data: let data):
                self.navigationController?.popViewController(animated: true)
                break
            case .requestFail,.responseFail:
        
                break;
            default :
                break
            }
        }

    }
}
