//
//  PLChangePasViewController.swift
//  Paoli
//
//  Created by 1 on 2021/9/29.
//

import UIKit

class PLChangePasViewController: PLBaseViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
        self.title = "修改密码"
        setUI()
    }
    
    func setUI(){
        self.view.addSubview(self.newWdTf)
        self.view.addSubview(self.oldWdTf)
        self.view.addSubview(self.loginBtn)
        
    }
    
    @objc func tapped(_ sender: UIButton){
        if sender.tag == 100 {

            changepwd(mobile: "", newPassword: self.newWdTf.text, oldPassword: self.oldWdTf.text)
        }
    }
    lazy var loginBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom);//新建btn
        btn.frame = CGRect.init(x: 20, y: 230, width: ScreenWidth-40, height: 45);//frame位置和大小
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
    lazy var oldWdTf : UITextField = {
       
        let textField = UITextField(frame: CGRect(x:20, y:170, width:ScreenWidth-40, height:45))
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "请输入旧密码"
        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.text = "123456"

        return textField;
    }()
    lazy var newWdTf: UITextField = {
       
        let textField = UITextField(frame: CGRect(x:20, y:120, width:ScreenWidth-40, height:45))
//        textField.text = "17688937355"
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.clearButtonMode = .unlessEditing  //编辑时不出现，编辑后才出现清除按钮
        textField.placeholder = "请输新密码"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.returnKeyType = UIReturnKeyType.next //表示继续下一步
        textField.keyboardType = .phonePad
        textField.backgroundColor = .white
        return textField;
    }()
 
}
extension PLChangePasViewController {
    
   
    func changepwd(mobile:String?,newPassword:String?,oldPassword:String?) {
        
        
        let moble = "\(AGUserDefaults().getUserDefaults(AGAccount) ?? "")"
        
        guard moble.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入手机号")
            return
        }
        guard newPassword?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入验证码")
            return
        }
        guard oldPassword?.count ?? 0 > 0 else {
            SVProgressHUD.showError(withStatus: "请输入新密码")
            return
        }
        
        let request = UserAPI.changePwd(account: moble, newPassword: newPassword!.md5, oldPassword: oldPassword!.md5)
        
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
