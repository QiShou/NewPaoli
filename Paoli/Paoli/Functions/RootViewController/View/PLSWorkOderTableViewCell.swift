//
//  PLSWorkOderTableViewCell.swift
//  PaoliBackend
//
//  Created by 0 on 2020/11/13.
//  Copyright © 2020 Ins24.com. All rights reserved.
//

import UIKit


typealias BtnBlock = (PBUserRoleModule)->Void

class PLSWorkOderTableViewCell: UITableViewCell {
    var actionview = UIView()
    var dataArr = Array<PBUserRoleModule>()
    var block:BtnBlock!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    func setUpUI(arr:Array<PBUserRoleModule>?,info:PLUserInfo,text: String)  {
        
        self.contentView.addSubview(self.tipLabel(text))
        self.contentView.addSubview(actionTtn(arr: arr ?? [],info: info))
        self.layoutIfNeeded()
       
    }
    

    func tipLabel(_ text:String) -> UIView {
        
        let actionviews = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 45))
        actionviews.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 12, y: 0, width: ScreenWidth-20, height: 45))
        label.textAlignment = .left;
        label.text = text
        label.textColor = UIColor.init(hexString:"333333")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = .white
        actionviews.addSubview(label)
        return actionviews
    }

    func actionTtn(arr:Array<PBUserRoleModule>,info:PLUserInfo) -> UIView {
        
        guard arr.count > 0 else {
            
            return UIView()
        }
        for view in actionview.subviews {
            
            view.removeFromSuperview()
        }
        actionview.removeFromSuperview()
       
        dataArr = arr
        actionview = UIView(frame: CGRect(x: 12, y: 45, width: ScreenWidth-24, height: 86))
        
        
        // strokeCode
        let borderLayer1 = CALayer()
        borderLayer1.frame = actionview.bounds
        borderLayer1.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1).cgColor
        actionview.layer.addSublayer(borderLayer1)
        // fillCode
        let bgLayer1 = CALayer()
        bgLayer1.frame = CGRect(x: 1, y: 1, width: ScreenWidth-24, height: 84)
        bgLayer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        actionview.layer.addSublayer(bgLayer1)
        // shadowCode
        actionview.layer.shadowColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 0.44).cgColor
        actionview.layer.shadowOffset = CGSize(width: 0, height: 5)
        actionview.layer.shadowOpacity = 1
        actionview.layer.shadowRadius = 15
        
        
        let margeW = 5
        let margeH = 5

        let btnWidth = (Int(ScreenWidth-24) - (arr.count + 1) * 5) / arr.count
        let btnHeight = btnWidth
        
        for i in 0 ..< arr.count {
            let rowIndex = i/arr.count
            let conIndex = i%arr.count
            
            let mainView = UIView.init(frame: CGRect(x:Int(btnWidth) * conIndex + Int(margeW) * (conIndex + 1),y:Int(btnHeight) * rowIndex + Int(margeH) * (rowIndex) , width: Int(btnWidth), height: Int(86)))
            mainView.backgroundColor = .white
            
            let  control = UIControl(frame: CGRect(x: 0, y: 0, width: mainView.width, height: mainView.height))
            control.addTarget(self, action: #selector(performAction(sender:)), for: .touchUpInside)
            control.tag = 1000+i
            mainView.addSubview(control)
            
            let iamgeview = UIImageView(frame: CGRect(x: (mainView.width-30)/2, y: 15, width: 30, height: 30))
            let url = URL.init(string: arr[i].iconUrl ?? "" )
            iamgeview.kf.setImage(with: url)
            mainView.addSubview(iamgeview)
            
            let label = UILabel(frame: CGRect(x: 0, y: 50, width: mainView.width, height: 20))
            label.textAlignment = .center;
            label.text = arr[i].name
            label.textColor = UIColor.init(hexString:"313131")
            label.font = UIFont.systemFont(ofSize: 13)
            mainView.addSubview(label)
            
            let numlabel = UILabel(frame: CGRect(x:iamgeview.frame.maxX-5, y:iamgeview.frame.minY-15, width:22, height:16))
            numlabel.adjustsFontSizeToFitWidth = true
            numlabel.textAlignment = .center;
            numlabel.textColor = .white
            numlabel.font = UIFont.systemFont(ofSize: 11)
            numlabel.layer.cornerRadius = 8.0
            numlabel.layer.masksToBounds = true
            numlabel.backgroundColor = UIColor.init(hexString: "F55023")

            let a:(num:Int,numlableHide:Bool,numlableFrame:Bool) = tipLabelsNumsAndFrame(arr[i].badgeNum ?? 0)

            numlabel.text = "\(a.num)"
            if a.numlableHide {
                numlabel.isHidden = true
            } else {
                if a.numlableFrame {
                    numlabel.frame = CGRect(x:iamgeview.frame.maxX-5, y:iamgeview.frame.minY-13, width:22, height:15)
                } else {
                    numlabel.frame = CGRect(x:iamgeview.frame.maxX-5, y:iamgeview.frame.minY-13, width:15, height:15)
                }
            }
            
            mainView.addSubview(numlabel)
            actionview.addSubview(mainView)
        }
        
        return actionview;
    }
    
    func tipLabelsNumsAndFrame(_ num:Int) -> (Int,Bool,Bool) {
        
        var hideNum = false
        var changeNumLFrame = true
        var endNum = 0
        
        if num == 0 {
            hideNum = true
            endNum = num
        } else if num > 0 && num < 10 {
            hideNum = false
            changeNumLFrame = false
            endNum = num
        } else if num >= 10 && num < 100 {
            hideNum = false
            endNum = num
        } else {
            endNum = 99
        }
        
        return (endNum,hideNum,changeNumLFrame)
    }
    
    @objc func performAction(sender:UIButton)  {
        
        let i = sender.tag - 1000
        let model = self.dataArr[i]
        if (self.block != nil) {
            block(model)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print("layoutIfNeeded")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
    }
    override func setNeedsLayout() {
        super.setNeedsDisplay()
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
