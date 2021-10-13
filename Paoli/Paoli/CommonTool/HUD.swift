//
//  HUD.swift
//  HDFSWallet
//
//  Created by YG on 2019/11/14.
//  Copyright © 2019 YG. All rights reserved.
//

import UIKit
import SVProgressHUD

public class HUD {
    
    /// 普通的文本Toast
    static func showToast(_ str: String) {
        dismiss()
        _hudConfig()
//        SVProgressHUD.show(UIImage(data: .empty, scale: .zero)!, status: str)
    }
    
    /// 成功吐司
    static func showSuccessToast(_ str: String) {
        dismiss()
        _hudConfig()
        SVProgressHUD.showSuccess(withStatus: str)
    }
    
    /// 警告吐司
    static func showInfoToast(_ str: String) {
        dismiss()
        _hudConfig()
        SVProgressHUD.showInfo(withStatus: str)
    }
    
    /// 失败吐司
    static func showErrorToast(_ str: String) {
        dismiss()
        _hudConfig()
        SVProgressHUD.showError(withStatus: str)
    }
    
    /// 全屏Loading, 无法交互
    static func showLoading() {
        dismiss()
        _hudConfig()
        _hudLoadingConfig()
        SVProgressHUD.show()
    }
    
    /// 全屏Loading带文字, 无法交互
    static func showLoading(_ str: String) {
        dismiss()
        _hudConfig()
        _hudLoadingConfig()
        SVProgressHUD.show(withStatus: str)
    }
    
    /// 移除Loading和Toast
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
}

extension HUD {
    private class func _hudConfig() {
       
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setFont(.systemFont(ofSize: 15))
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setMaximumDismissTimeInterval(1.5)
        SVProgressHUD.setCornerRadius(6)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: UIApplication.shared.statusBarFrame.size.height))
        SVProgressHUD.setContainerView(nil)
    }
    
    private class func _hudLoadingConfig() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
    }
}


extension UIViewController {
    
    func alert(title: String, message: String? = nil, block: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: {_ in
            block?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func confirm(title: String, message: String? = nil, block: (() -> Void)? = nil) {
        let confirm = UIAlertController(title: title, message: message, preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: {_ in
            block?()
        }))
        confirm.addAction(UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil))
        present(confirm, animated: true, completion: nil)
    }
}
