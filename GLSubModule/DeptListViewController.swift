//
//  DeptListViewController.swift
//  GLSubModule
//
//  Created by Kathy on 2021/8/19.
//

import UIKit

class DeptListViewController: UITableViewController {

    var dept:Dept?
    
    typealias DeptCompletion = (Dept)->()
    
    var completion: DeptCompletion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "部门表"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightClick))
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新", attributes: nil)
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        tableView.tableFooterView = UIView()
        loadNewData()
    }
    
    @objc func refreshTableView() -> () {
        loadNewData()
    }
    
    func loadNewData() {
        self.dataArray = (GLCoreDataManager.shared.fetchData(with: "Dept", predicate: nil) as? [Dept]) ?? [Dept]()
        self.tableView.reloadData()
        endRefresh()
    }
    
    func endRefresh() -> () {
        DispatchQueue.main.async {
            if self.tableView.refreshControl?.isRefreshing ?? false {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func rightClick() {
        let vc = UIAlertController(title: "添加职位", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel) { action in
            
        }
        let action2 = UIAlertAction(title: "确认", style: .default) { action in
            
            guard let textField = vc.textFields?.first else {
                return
            }
            guard textField.text?.count ?? 0 > 0 else {
                return
            }
            GLCoreDataManager.shared.addData(with: "Dept") { object in
                if let dept = object as? Dept {
                    dept.name = textField.text
                }
            }
            self.loadNewData()
        }
        vc.addAction(action1)
        vc.addAction(action2)
        vc.addTextField { textField in
            
        }
        present(vc, animated: true, completion: nil)
    }

    var dataArray:[Dept] = [Dept]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let dept = self.dataArray[indexPath.row]
        cell?.textLabel?.text = dept.name
        cell?.detailTextLabel?.text = "\(dept.users?.count ?? 0)人"
        if dept == self.dept {
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction(style: .normal, title: "编辑") {[weak self] action, indexPath in
            self?.editData(indexPath.row)
        }
        let action2 = UITableViewRowAction(style: .destructive, title: "删除") {[weak self] action, indexPath in
            self?.deleteData(indexPath.row)
        }
        return [action2, action1]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let m = self.completion {
            m(self.dataArray[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func deleteData(_ index: Int) {
        let dept = self.dataArray[index]
        GLCoreDataManager.shared.persistentContainer.viewContext.delete(dept)
        GLCoreDataManager.shared.saveContext()
        self.dataArray.remove(at: index)
        self.tableView.reloadData()
    }
    
    func editData(_ index: Int) {
        let dept = self.dataArray[index]
        let vc = UIAlertController(title: "编辑职位", message: nil, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel) { action in
            
        }
        let action2 = UIAlertAction(title: "确认", style: .default) { action in
            
            guard let textField = vc.textFields?.first else {
                return
            }
            guard textField.text?.count ?? 0 > 0 else {
                return
            }
            if textField.text == dept.name{
                
            }else{
                dept.name = textField.text
                GLCoreDataManager.shared.saveContext()
                self.tableView.reloadData()
                if dept.id == self.dept?.id {
                    if let m = self.completion {
                        m(dept)
                    }
                }
            }
        }
        vc.addAction(action1)
        vc.addAction(action2)
        vc.addTextField { textField in
            textField.text = dept.name
        }
        present(vc, animated: true, completion: nil)
    }
    
}
