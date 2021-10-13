//
//  BaseTableViewController.swift
//  AgentTool
//
//  Created by Wxb on 2020/8/22.
//  Copyright © 2020 深圳市腾付通电子支付科技有限公司. All rights reserved.
//

import UIKit

class BaseTableViewController: PLBaseViewViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pageSize :UInt = 20
    var page :UInt = 1
    var dataArr :[Any] = []
    var emptyView : LYEmptyView?
    lazy var tableView :UITableView = {
        
        let vc = UITableViewController()
        self.addChild(vc)
        vc.tableView.delegate = self
        vc.tableView.dataSource = self
        vc.tableView.tableFooterView = UIView()
        return vc.tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func handleComListRes<M:HandyJSON,T>(res:RequestResult<M>,type:T.Type,locData:Bool) {
        
        
        switch res {
            
        case .requestFail,.responseFail:
            
          
            if locData && dataArr.count>0{
                
                tableView.mj_footer?.isHidden = true
                tableView.mj_header?.endRefreshing()
                tableView.mj_footer?.endRefreshing()
            
                self.tableView.reloadData()
            } else {
                
                if self.page > 1 {
                    self.page -= 1
                }
                
                if self.page == 1 {
                    
                    tableView.ly_emptyView = LYEmptyView.emptyActionView(withImageStr: "merchants_nodata", titleStr: "请求异常", detailStr: "", btnTitleStr: "", btnClick: {
                        
                    })
                    
                }
            }
            
            
        case .responseObject(let obj):
            
            handleComListRes(res: res, type: type)
            
        default:
            break
        }
        
    }
    

    
    func handleComListRes<M:HandyJSON,T>(res:RequestResult<M>,type:T.Type){
        
        switch res {
            
        case .requestFail,.responseFail:
            
            if self.page > 1 {
               self.page -= 1
            }
            
            if self.page == 1 {

                tableView.ly_emptyView = LYEmptyView.emptyActionView(withImageStr: "merchants_nodata", titleStr: "请求异常", detailStr: "", btnTitleStr: "", btnClick: {
                
                })

            }
            
        case .responseObject(let obj):
            
            let model = obj as! CommonListRes<T>
            
            self.loadData(tableView: self.tableView, page: self.page, result:RequestResult.responseArray(dataArr:(model.records ?? model.tabMenu)!))
            
//        case .responseNoMap(let data ):
//            self.page = data["pages"]

//            self.loadData(tableView: self.tableView, page: data["page"], result: <#T##RequestResult<M>#>)
            
        default:
            break
        }
        
    }
    
    func loadData<M>(tableView:UITableView,page : UInt,result : RequestResult<M>,firstIndex : UInt = 1){
        
            tableView.mj_footer?.isHidden = false
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshing()
        
            switch result {
            case .responseArray(let arr):
            
                if page == 1 {
                    self.dataArr.removeAll()
                }
                
                self.dataArr.append(contentsOf: arr)
                tableView.reloadData()
                
                if arr.count < pageSize {
                    tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
                
            if page == 1 && arr.count == 0 {
                
                tableView.mj_footer?.isHidden = true
                
                if let view = self.emptyView {
                    
                    tableView.ly_emptyView = view
                    
                } else {
                    
                    tableView.ly_emptyView = LYEmptyView.empty(withImageStr:"merchants_nodata", titleStr: "暂无数据", detailStr: "")

//              tableView.ep.setEmpty(EmptyPageForStandard().config(imageView: { (item) in
//                          item.image = UIImage.init(named: "merchants_nodata")
//                      }).config(textLabel: { (item) in
//                          item.text = "暂无数据"
//                          item.font = UIFont.pingFangMedium(size:15)
//                          item.textColor = UIColor.init(hexString:"7A8599")
//
//                      }).mix())
                }
            }
                
           case .responseNoData:

               if page == firstIndex {

                   dataArr.removeAll()
                   tableView.mj_footer?.resetNoMoreData()
                   self.page = firstIndex
                   
               }else{

                   tableView.mj_footer?.endRefreshingWithNoMoreData()
               }

               tableView.reloadData()

           case .responseObject(let model):
               
               self.dataArr = [model]
               tableView.reloadData()
               
           case .requestFail:
               
               return
           default:break

           }

           if self.dataArr.count == 0{
               
           }
       }
 
//    
}

extension BaseTableViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
    
}

