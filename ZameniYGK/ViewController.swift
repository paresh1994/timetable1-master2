//
//  ViewController.swift
//  ZameniYGK
//
//  Created by Веригин С.И. on 04.04.18.
//  Copyright © 2018 Веригин С.И. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
  
  
    @IBOutlet var groupn: UILabel!
    @IBOutlet weak var MyTableView: UITableView!
    
    var schedule = [ScheduleItem]()
    
    class ScheduleItem {
        var group: String = ""
        
        var number: String = ""
        
        var discipline: String = ""
        
        var zamen: String = ""
        
        var audit: String = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.MyTableView.delegate = self
        self.MyTableView.dataSource = self
        

        let url = URL(string: "http://ftp.sttec.yar.ru/pub/timetable/rasp_first.html")
        
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print (error?.localizedDescription ?? "error description not found")
            }
            else {
                
                if let unwrappedData = data {
                    if let htmlContentString = String.init(data: unwrappedData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        do{
                            
                            let doc : Document = try SwiftSoup.parse(htmlContentString)
                            
                            let tableBody = try doc.select("tbody").first()
                            
                            let allRows = try tableBody?.select("tr").array()
                            
                            
                            for (inde,rowElement) in allRows!.enumerated() {
                                
                                let rowEntries = try rowElement.select("td").array()
                                
                                if inde == 0 {
                                    continue
                                }
                                let timetable = ScheduleItem()
                                for (index, column) in rowEntries.enumerated() {
                                    
                                    switch(index) {
                                        
                                    case 1:
                                        timetable.number = try column.text()
                                        
                                    case 2:
                                        
                                        timetable.discipline = try column.text()
                                        
                                    case 3:
                                        
                                        timetable.zamen = try column.text()
                                       
                                    case 4:
                                        
                                        timetable.audit = try column.text()
                                    
                                        
                                    default:
                                        break
                                        
                                    }
                                    
                                    self.schedule.append(timetable)
                                    
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.MyTableView.reloadData()
                            }
                        }catch{
                            print(error.localizedDescription)
                        }
                        
                        
                    }
                    else {
                        print("Could not create html content string from data")
                    }
                }
                else {
                    print ("could not unwrapp data object for html content")
                }
                
            }
            
        }
        
        
        task.resume()
        
        
        
    }
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return schedule.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text = schedule[indexPath.row].zamen
            return cell
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


