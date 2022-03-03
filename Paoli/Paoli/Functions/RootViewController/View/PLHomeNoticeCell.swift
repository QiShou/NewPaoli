//
//  PLHomeNoticeCell.swift
//  Paoli
//
//  Created by 0 on 2021/12/20.
//

import UIKit

class PLHomeNoticeCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setUpUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI()  {
        
        backView.addSubview(notiTitle)
        backView.addSubview(lineView)
        backView.addSubview(img)
        contentView.addSubview(backView)
    }
    
    lazy var backView : UIView = {
        let v = UIView(frame: CGRect(x: 10, y: 10, width: ScreenWidth-20, height: 64))
      
        return v
    }()
    
    lazy var notiTitle : UILabel = {
        
        let t = UILabel()
        t.frame = CGRect(x: 77, y: 10, width: 210, height: 44)
        
        t.text = "您有一个订单待支付。\n2021年12月国人通信大厦消杀通知。"
        t.numberOfLines = 20
        t.textColor = .init(hexString: "#333333")
        
        t.font = .systemFont(ofSize: 12)
        return t
        
    }()
    
    lazy var lineView : UIView = {
        let v = UIView(frame: CGRect(x: 62, y: 15, width: 1, height: 34))
        v.backgroundColor = .init(hexString: "#DDDDDD")
        return v
    }()
    
    lazy var img : UIImageView = {
       let imgs = UIImageView(frame: CGRect(x: 15, y: 14, width: 41, height: 43))
        imgs.image = UIImage(named: "home_ic_notice")
        
        return imgs
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
