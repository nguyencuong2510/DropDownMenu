//
//  DropDownVC.swift
//  DropDownMenu
//
//  Created by admin on 10/9/18.
//  Copyright © 2018 cuongnv. All rights reserved.
//

import UIKit

class DropDownVC: UIViewController {
    
    @IBOutlet weak var dropButtonView: dropDownButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropButtonView.inputData(list: ["item 1", "item 2", "item 1", "item 2"]) { (index) in
            print(index)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dropButtonView.isOpen {
            dropButtonView.touchesBegan(touches, with: event)
        }
    }
}

class dropDownButton: UIView {
    
    var isOpen = false
    var maxHeight: CGFloat = 150
    
    var dropDownView = vTableDataSourceDelegate(frame: .zero)
    
    private var height = NSLayoutConstraint()
    
    private func showDropDown() {
        isOpen ? hiden() : show()
        isOpen = isOpen == true ? false : true
    }
    
    override func didMoveToSuperview() {
        
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubviewToFront(dropDownView)
        
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropDownView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showDropDown()
    }
    
    private func show() {
        superview?.subviews.forEach{ (vc) in
            guard vc is vTableDataSourceDelegate || vc is dropDownButton else {
                vc.isUserInteractionEnabled = false
                vc.alpha = 0.3
                return
            }
        }
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 150
        NSLayoutConstraint.activate([self.height])
        
        self.height.constant = self.dropDownView.tableView.contentSize.height > maxHeight ? maxHeight : dropDownView.tableView.contentSize.height
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            self.dropDownView.layoutIfNeeded()
            self.dropDownView.center.y += self.dropDownView.frame.height / 2
        }, completion: nil)
    }
    
    private func hiden() {
        superview?.subviews.forEach{ (vc) in
            vc.isUserInteractionEnabled = true
            vc.alpha = 1
        }
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropDownView.center.y -= self.dropDownView.frame.height / 2
            self.dropDownView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func inputData<T>(list: [T],index selected: Response) {
        
    }
}

typealias Response = ((_ index: IndexPath) -> Void)

class vTableDataSourceDelegate: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var listData = [String]()
    var identifiCell: String = ""
    
    let tableView = UITableView()
    private var seletedIndex: Response?
    
    var background: UIColor = UIColor.gray {
        didSet{ backgroundColor = background }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        tableView.register(UINib(nibName: identifiCell, bundle: nil), forCellReuseIdentifier: identifiCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: identifiCell, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO:
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        seletedIndex!(indexPath)
    }
}

