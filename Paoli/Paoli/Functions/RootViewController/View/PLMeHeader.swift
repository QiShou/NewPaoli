//
//  PLMeHeader.swift
//  Paoli
//
//  Created by 1 on 2021/9/29.
//

import UIKit

class PLMeHeader: UIView {
    var str:String?
    
    init(frame:CGRect,str:String?) {
        
        super.init(frame: frame)
        self.str = str
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI()  {
        self.addSubview(img)
        self.addSubview(nlab)
    }
    var model:PLUserInfo? {
        didSet {
            self.nlab.text = model?.nickName ?? "-"
        }
    }
    lazy var img : UIImageView = {
       let imgs = UIImageView(frame: CGRect(x: 20, y: 40, width: 60, height: 60))
        imgs.image = UIImage(named: "pic_account")
        
        return imgs
    }()
    
    lazy var nlab : UILabel = {
       let lab = UILabel(frame: CGRect(x: 90, y: 50, width: 200, height: 40))
        lab.text = "-"
        lab.textAlignment = .left
        lab.textColor = UIColor(hexString: "333333")
        lab.font = .systemFont(ofSize: 16)
        
        return lab
    }()
}
