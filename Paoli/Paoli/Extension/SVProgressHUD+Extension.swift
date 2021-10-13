//
//  SVProgressHUD+Extension.swift
//  News
//

extension SVProgressHUD {
    /// 设置 SVProgressHUD 属性
    static func configuration() {
        
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.6))
        SVProgressHUD.setImageViewSize(CGSize.zero)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
}


