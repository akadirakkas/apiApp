//
//  DateSelectionTableViewController.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 24.03.2021.
//

import UIKit

class DateSelectionTableViewController: UITableViewController{
    
    var timeSeriesMonthlyAdjusted : TimeSeriesMonthlyAdjusted?
    private var monthInfos : [MonthInfo] = []
    var didSelectDate : ((Int) -> Void)?
    
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonthInfos()
        setupNavigation()
    }
    
    
    private func setupNavigation() {
        title = "Select Date"
    }
    
   private func  setupMonthInfos()  {
    monthInfos = timeSeriesMonthlyAdjusted?.getMonthInfos() ?? []
    }
}
extension DateSelectionTableViewController  {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthInfos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.item
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as!
            DateSelectionTableViewCell
        let monthInfo = monthInfos[index]
        let isSelected = index == selectedIndex
        cell.configure(with: monthInfo, index: index , isSelected: isSelected)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


class DateSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var monthsAgoLabel : UILabel!
    
    func configure(with monthInfo : MonthInfo , index : Int , isSelected : Bool){
        monthLabel.text = monthInfo.date.MMYYFormat
        accessoryType = isSelected ? .checkmark : .none
        
        if index == 1 {
            monthsAgoLabel.text = "1 months ago"
        }else if index > 1 {
            monthsAgoLabel.text = "\(index) months ago"
        }else {
            monthsAgoLabel.text = "Just invested"
        }
    }
    
    
}

