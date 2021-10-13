//
//  TFTCountdownButton.swift
//  TFTMPOS
//
//  Created by wangxb on 2020/4/2.
//  Copyright © 2020 tftpay. All rights reserved.
//

import UIKit

public enum CountdownState: Int {
    case normal = 0, countdown, reget
}

typealias CountdownButtonCallBack = (CountdownButton, CountdownState, Int) -> Void

class CountdownButton: UIButton {

    /// 按钮状态
       private var _state: CountdownState! {
           didSet {
               if let state = _state {
                   _totalCount = totalCount
                   isEnabled = state != .countdown
                   callback(self, _state, _totalCount)
                   if (state == .countdown) {
                       if (timer == nil) {
                           timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
                           timer?.fire()
                       }
                   } else {
                       if (timer != nil) {
                           timer?.invalidate()
                           timer = nil
                       }
                   }
               }
           }
       }
    
    /// 按钮回调
       private var callback: CountdownButtonCallBack!
       
       /// 计时器
       private var timer: Timer?
       
       /// 计时计数
       private var _totalCount: Int = 0
       
       /// 默认计数
       private var totalCount: Int = 10
    
    /// 初始化
       public convenience init(frame: CGRect, callback: @escaping CountdownButtonCallBack) {
           self.init(frame: frame)
           self.callback = callback
           reset()
       }
       
       /// 开始
       public func start(_ count: Int = 60) {
           totalCount = count
           _state = .countdown
       }
       
       /// 结束
       public func stop() {
           _state = .reget
       }
       
       /// 重置
       public func reset() {
           _state = .normal
       }
    
    /// 计时器方法
       @objc private func countdown() {
           if (_totalCount <= 0) {
               stop()
           } else {
               callback(self, _state, _totalCount)
               _totalCount -= 1
           }
       }
       
       /// 初始化
       private override init(frame: CGRect) {
           super.init(frame: frame)
       }

       /// 停止计时器
       override func removeFromSuperview() {
           super.removeFromSuperview()
           stop()
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       

}
