//
//  UIKit+Extension.swift
//  News
//
//  Created by 杨蒙 on 2017/12/12.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import CoreText

protocol StoryboardLoadable {}

extension StoryboardLoadable where Self: UIViewController {
    /// 提供 加载方法
    static func loadStoryboard() -> Self {
        return UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

protocol NibLoadable {}

extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}

extension UILabel {
    
    /// 设置问答的内容
    func setSeparatedLinesFrom(_ attributedString: NSMutableAttributedString, hasImage: Bool) {
        // 通过 CoreText 创建字体
        let ctFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        // 段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        // 为富文本添加属性
        attributedString.addAttributes([kCTFontAttributeName as NSAttributedString.Key: ctFont, NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
        // 通过 CoreText 创建 frameSetter
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        // 创建路径
        let path = CGMutablePath()
        // 为路径添加一个 frame
        path.addRect(CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        // 通过 CoreText 创建 frame
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: attributedString.length), path, nil)
        // 获取当前 frame 中的每一行的内容
        let lines: NSArray = CTFrameGetLines(frame)
        
        let attributedStrings = NSMutableAttributedString()
        // 遍历
        for (index, line) in lines.enumerated() {
            // 将 line 转成 CTLine
            // 获取每一行的范围
            let lineRange = CTLineGetStringRange(line as! CTLine)
            // 将 lineRange 转成 NSRange
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            // 当前的内容
            let currentAttributedString = NSMutableAttributedString(attributedString: attributedString.attributedSubstring(from: range))
            if hasImage { // 如果有图片，就把第四行替换
                if index == 3 && currentAttributedString.length >= 18 {
                    replaceContent(currentAttributedString)
                }
            } else { // 如果没有图片，就把第六行替换
                if index == 5 && currentAttributedString.length >= 18 {
                    replaceContent(currentAttributedString)
                }
            }
            attributedStrings.append(currentAttributedString)
        }
        attributedText = attributedStrings
    }
    
    /// 替换内容
    private func replaceContent(_ currentAttributedString: NSMutableAttributedString) {
        currentAttributedString.replaceCharacters(in: NSRange(location: currentAttributedString.length - 8, length: 8), with: NSAttributedString(string: "...全文\n", attributes: [.foregroundColor: UIColor.blueFontColor()]))
    }
    
}

extension UITextField {
    
    func setInputCompletionToolBar(title:String,target:Any? = self, action:Selector = #selector(endEditing(_:))) {
        
        let toolBar = UIToolbar()
        //可以让UIBarButtonItem靠右显示
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title:title, style: .plain, target: target, action: action)
        toolBar.sizeToFit()
        toolBar.items = [spaceItem, doneItem]
        self.inputAccessoryView = toolBar
    }

}

extension UITextView {
    
    func setInputCompletionToolBar(title:String,target:Any? = self, action:Selector = #selector(endEditing(_:))) {
        
        let toolBar = UIToolbar()
        //可以让UIBarButtonItem靠右显示
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title:title, style: .plain, target: target, action: action)
        toolBar.sizeToFit()
        toolBar.items = [spaceItem, doneItem]
        self.inputAccessoryView = toolBar
    }

}

/*
extension UITextView {
    
    /// 设置 UITextView 富文本内容
    func setAttributedText(emoji: Emoji) {
        // 如果输入是空表情
        if emoji.isEmpty { return }
        // 如果输入是删除表情
        if emoji.isDelete { deleteBackward(); return }

        // 创建附件
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: emoji.png)
        // 当前字体的大小
        let currentFont = font!
        // 附件的大小
        attachment.bounds = CGRect(x: 0, y: -4, width: currentFont.lineHeight, height: currentFont.lineHeight)
        // 根据附件，创建富文本
        let attributedImageStr = NSAttributedString(attachment: attachment)
        // 获取当前的光标的位置
        let range = selectedRange
        // 设置富文本
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedText.replaceCharacters(in: range, with: attributedImageStr)
        attributedText = mutableAttributedText
        // 将字体的大小重置
        font = currentFont
        // 光标 + 1
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
    
}
 */

 extension UIView {
    
    /// x
    var x: CGFloat {
        get { return frame.origin.x }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat {
        get { return frame.origin.y }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    var height: CGFloat {
        get { return frame.size.height }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var width: CGFloat {
        get { return frame.size.width }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width  = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var size: CGSize {
        get { return frame.size }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size        = newValue
            frame                 = tempFrame
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get { return center.x }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x            = newValue
            center                  = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get { return center.y }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y            = newValue
            center                  = tempCenter;
        }
    }
//    self.backgroundColor = UIColor.white
//    let subView = UIView.init(frame:self.bounds)
//    subView.layer.masksToBounds = true;
//    subView.layer.shadowRadius = 4;
//    self.addSubview(subView)
//
//    func clipCorner( topLeft :(Bool,CGSize) = (false,CGSize.zero),topRight:(Bool,CGSize) = (false,CGSize.zero),bottomLeft:(Bool,CGSize) = (false,CGSize.zero),bottomRight:(Bool,CGSize) = (false,CGSize.zero)){
//        var arr :
//        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: UIRectCorner, cornerRadii: <#T##CGSize#>)
//    }
    func clipCorner(corners:UIRectCorner,cornerRadii:CGSize){
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:corners, cornerRadii:cornerRadii).cgPath
        self.layer.mask = maskLayer
        
    }
//    func addShadowAndcorner(shadowColor:CGColor,offset:CGSize,shadowOpacity:Float,cornerRadius:CGFloat){
//
//        let subView = UIView()
//        self.insertSubview(subView, at: 0)
//        subView.snp_makeConstraints { (maker) in
//            maker.top.equalToSuperview()
//            maker.bottom.equalToSuperview()
//            maker.left.equalToSuperview()
//            maker.right.equalToSuperview()
//        }
//        subView.layer.masksToBounds = true;
//        subView.layer.shadowRadius = cornerRadius;
//
//
//        self.layer.cornerRadius = cornerRadius
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = shadowColor
//        self.layer.shadowOffset = offset
//        self.layer.shadowOpacity = shadowOpacity;
//
//    }
}

protocol CellModelRelation {}

protocol RegisterCellFromNib {}

extension RegisterCellFromNib {
    
    static var identifier: String { return "\(self)" }
    
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
    
}

protocol ModelRelation {
    
    func setModel(model:HandyJSON)
}

extension UITableView {
    /// 注册 cell 的方法
    func ym_registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib { register(nib, forCellReuseIdentifier: T.identifier) }
        else { register(cell, forCellReuseIdentifier: T.identifier) }
    }
    
    /// 从缓存池池出队已经存在的 cell
    func ym_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    /// 注册 cell 的方法
    func ym_registerCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib { register(nib, forCellWithReuseIdentifier: T.identifier) }
        else { register(cell, forCellWithReuseIdentifier: T.identifier) }
    }
    
    /// 从缓存池池出队已经存在的 cell
    func ym_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 注册头部
    func ym_registerSupplementaryHeaderView<T: UICollectionReusableView>(reusableView: T.Type) where T: RegisterCellFromNib {
        // T 遵守了 RegisterCellOrNib 协议，所以通过 T 就能取出 identifier 这个属性
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        }
    }
    
    /// 获取可重用的头部
    func ym_dequeueReusableSupplementaryHeaderView<T: UICollectionReusableView>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UIImageView {
    /// 设置图片圆角
    func circleImage() {
        /// 建立上下文
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        /// 获取当前上下文
        let ctx = UIGraphicsGetCurrentContext()
        /// 添加一个圆，并裁剪
        ctx?.addEllipse(in: self.bounds)
        ctx?.clip()
        /// 绘制图像
        self.draw(self.bounds)
        /// 获取绘制的图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        /// 关闭上下文
        UIGraphicsEndImageContext()
        DispatchQueue.global().async {
            self.image = image
        }
    }
    
}

extension UIColor {
    
    //        self.init(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 背景灰色 f8f9f7
    class func globalBackgroundColor() -> UIColor {
        return UIColor(r: 248, g: 249, b: 247)
    }
    
    /// 背景红色
    class func globalRedColor() -> UIColor {
        return UIColor(r: 196, g: 73, b: 67)
    }
    
    /// 字体蓝色
    class func blueFontColor() -> UIColor {
        return UIColor(r: 72, g: 100, b: 149)
    }
    
    /// 背景灰色 132
    class func grayColor132() -> UIColor {
        return UIColor(r: 132, g: 132, b: 132)
    }
    
    /// 背景灰色 232
    class func grayColor232() -> UIColor {
        return UIColor(r: 232, g: 232, b: 232)
    }
    
    /// 夜间字体背景灰色 113
    class func grayColor113() -> UIColor {
        return UIColor(r: 113, g: 113, b: 113)
    }
    
    /// 夜间背景灰色 37
    class func grayColor37() -> UIColor {
        return UIColor(r: 37, g: 37, b: 37)
    }
    
    /// 灰色 210
    class func grayColor210() -> UIColor {
        return UIColor(r: 210, g: 210, b: 210)
    }
    
    convenience init(hexString:String){
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
}

extension UIFont {
    
   static func pingFangMedium(size:CGFloat) -> UIFont {
        
        return UIFont.init(name:"PingFang-SC-Medium", size: size)!
    }
   static func pingFangSemibold(size:CGFloat) -> UIFont {
        
        return UIFont.init(name:"PingFangSC-Semibold", size: size)!
    }
    
}

extension UIImage{
    
 
        func scaled(to newSize: CGSize) -> UIImage {
            
            if self.size.width < newSize.width,self.size.height < newSize.height {
                
                return self
            }
            
            //计算比例
            let aspectWidth  = newSize.width/self.size.width
            let aspectHeight = newSize.height/self.size.height
            let aspectRatio = max(aspectWidth, aspectHeight)
            
            //图片绘制区域
            var scaledImageRect = CGRect.zero
            scaledImageRect.size.width  = size.width * aspectRatio
            scaledImageRect.size.height = size.height * aspectRatio
            scaledImageRect.origin.x    = 0
            scaledImageRect.origin.y    = 0
            
            //绘制并获取最终图片
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)//图片不失真
            draw(in: scaledImageRect)
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return scaledImage!
        }
    
    func createRotatedImage(rota:CGFloat)->UIImage{
        //FIXME:-方法待完成
//        var transform = CGAffineTransform.identity
//
//        let w = Int(self.size.width)
//        let h = Int(self.size.height)
//        let bitsPerComponent = 8
//        let bytesPerRow = w * 4
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
//        let bufferData = UnsafeMutablePointer<UInt32>.allocate(capacity: w * h)
//        bufferData.initialize(repeating: 0, count: w * h)
//        let cxt = CGContext(data: bufferData,
//                                    width: w,
//                                    height: h,
//                                    bitsPerComponent: bitsPerComponent,
//                                    bytesPerRow: bytesPerRow,
//                                    space: colorSpace,
//                                    bitmapInfo: bitmapInfo)!
        
        return UIImage()
        
        
        }
    
}




extension UIAlertController {
    
    //在指定视图控制器上弹出普通消息提示框
    static func showAlert(title:String? = nil,message: String, in viewController: UIViewController,confirm: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let action = confirm {
            
            alert.addAction(UIAlertAction(title: "确定", style: .default,handler: action))

        } else {
            alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        }
        viewController.present(alert, animated: true)
    }
      
    //在根视图控制器上弹出普通消息提示框
    static func showAlert(title:String? = nil, message: String,confirm: ((UIAlertAction)->Void)? = nil) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(title: title,message: message, in: vc,confirm: confirm)
        }
    }
     
    //在指定视图控制器上弹出确认框
    static func showConfirm(title:String? = nil,message: String, in viewController: UIViewController,
                            confirm: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
        viewController.present(alert, animated: true)
    }
     
    //在根视图控制器上弹出确认框
    static func showConfirm(title:String? = nil,message: String, confirm: ((UIAlertAction)->Void)?) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(title:title,message: message, in: vc, confirm: confirm)
        }
    }
}
