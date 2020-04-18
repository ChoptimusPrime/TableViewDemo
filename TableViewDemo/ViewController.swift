//
//  ViewController.swift
//  TableViewDemo
//
//  Created by Jonathan Compton on 4/17/20.
//  Copyright © 2020 Jonathan Compton. All rights reserved.
//

import UIKit

struct K {
    static let cellId = "cellId"
}

class ViewController: UIViewController {
    
    var natureItems = [DataItem]()
    var animalItems = [DataItem]()
    var allItems = [[DataItem]]()

    let tableView: UITableView = {
        var tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        //v.separatorStyle = .none
        tv.backgroundColor = .white
        tv.allowsSelectionDuringEditing = true
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nature Pictures"
        navigationItem.rightBarButtonItem = editButtonItem
        addTableView()
        loadDataItems()
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: K.cellId)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func loadDataItems() {
        for i in 1...12 {
            if i > 9 {
                natureItems.append(DataItem(title: "Title #\(i)", subtitle: "This is Subtitle #\(i)", imageName: "images/img\(i).jpg"))
            } else {
                natureItems.append(DataItem(title: "Title #0\(i)", subtitle: "This is Subtitle #\(i)", imageName: "images/img0\(i).jpg"))
            }
        }
        for i in 1...12 {
            if i > 9 {
                animalItems.append(DataItem(title: "Animal Title #\(i)", subtitle: "This is Animal Subtitle #\(i)", imageName: "images/anim\(i).jpg"))
            } else {
                animalItems.append(DataItem(title: "Animal Title #0\(i)", subtitle: "This is Animal Subtitle #0\(i)", imageName: "images/anim0\(i).jpg"))
            }
        }
        allItems.append(natureItems)
        allItems.append(animalItems)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            
            for (index, sectionItems) in allItems.enumerated() {
                let indexPath = IndexPath(row: sectionItems.count, section: index)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
        
        
    }
    
    


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section #\(section)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
          
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let addedRow = isEditing ? 1 : 0
        return allItems[section].count + addedRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellId, for: indexPath) as! SubtitleCell
        if indexPath.row >= allItems[indexPath.section].count && isEditing {
            cell.textLabel?.text = "Add New Item"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
            let dataItem = allItems[indexPath.section][indexPath.row]
            cell.textLabel?.text = dataItem.title
            cell.detailTextLabel?.text = dataItem.subtitle
            if let imageView = cell.imageView, let itemImage = dataItem.image {
                imageView.image = itemImage
            } else {
                cell.imageView?.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allItems[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            let newData = DataItem(title: "New Data", subtitle: "", imageName: nil)
            allItems[indexPath.section].append(newData)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = allItems[sourceIndexPath.section][sourceIndexPath.row]
        
        allItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        
        if sourceIndexPath.section == destinationIndexPath.section {
            allItems[sourceIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        } else {
            allItems[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        }
    }
    

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sectionItems = allItems[indexPath.section]
        if isEditing && indexPath.row < sectionItems.count {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionItems = allItems[indexPath.section]
        if indexPath.row >= sectionItems.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let sectionItems = allItems[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= sectionItems.count {
            return IndexPath(row: sectionItems.count - 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
}

class SubtitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: K.cellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

