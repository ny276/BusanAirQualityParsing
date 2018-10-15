//  Data Class 사용
//  ViewController.swift
//  BusanAirQualityParsing
//
//  Created by 김종현 on 2018. 9. 15..
//  Copyright © 2018년 김종현. All rights reserved.
//  XCode 9.41

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
      
      @IBOutlet weak var myTableView: UITableView!
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = myTableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
            
            let pm10 = cell.viewWithTag(1) as! UILabel
            let pm10Cai = cell.viewWithTag(2) as! UILabel
            let site = cell.viewWithTag(3) as! UILabel
            
            pm10.text = items[indexPath.row].dPm10
            pm10Cai.text = items[indexPath.row].dPm10Cai
            site.text = items[indexPath.row].dSite
            
            return cell
      }
      
      var items = [AirQuailtyData]()
      var item = AirQuailtyData()
      var myPm10 = ""
      var mySite = ""
      var myPm10Cai = ""
      var currentElement = ""
      var currentTime = ""
      
      override func viewDidLoad() {
            super.viewDidLoad()
            myTableView.delegate = self
            myTableView.dataSource = self
            myParse()
      }
      
      func myParse() {
            // Do any additional setup after loading the view, typically from a nib.
            let key = "1g1g0KxLSr%2BwQVe2RQSgj2XrXa84lY8gY1O0%2BZZeFV8n5c1r7RDdM3AOhB4WQzfCu4%2B5h%2BYAeO8asZLD4YdjuA%3D%3D"
            
            let strURL = "http://opendata.busan.go.kr/openapi/service/AirQualityInfoService/getAirQualityInfoClassifiedByStation?ServiceKey=\(key)&numOfRows=21"
            
            if let url = URL(string: strURL) {
                  if let parser = XMLParser(contentsOf: url) {
                        parser.delegate = self
                        
                        if (parser.parse()) {
                              print("parsing success")
                              print("PM 10 in Busan")
                              
                              let date: Date = Date()
                              let dayTimePeriodFormatter = DateFormatter()
                              dayTimePeriodFormatter.dateFormat = "YYYY/MM/dd HH시"
                              currentTime = dayTimePeriodFormatter.string(from: date)
                              print(currentTime)
                              print("PM10")
                              for i in 0..<items.count {
                                    switch items[i].dPm10Cai {
                                    case "1" : items[i].dPm10Cai = "좋음"
                                    case "2" : items[i].dPm10Cai = "보통"
                                    case "3" : items[i].dPm10Cai = "좋음"
                                    case "4" : items[i].dPm10Cai = "매우좋음"
                                    default : break
                                    }
                                    print("\(items[i].dSite) : \(items[i].dPm10)  \(items[i].dPm10Cai)")
                              }
                        } else {
                              print("parsing fail")
                        }
                  } else {
                        print("url error")
                  }
            }
      }
      
      // XML Parser Delegate
      func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            currentElement = elementName
      }
      
      func parser(_ parser: XMLParser, foundCharacters string: String) {
            let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            if !data.isEmpty {
                  //            print("data = \(data)")
                  switch currentElement {
                  case "pm10" : myPm10 = data
                  case "pm10Cai" : myPm10Cai = data
                  case "site" : mySite = data
                  default : break
                  }
                  //            print("pm10Cai = \(myPm10Cai)")
            }
      }
      
      func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "item" {
                  let myItem = AirQuailtyData()
                  myItem.dPm10 = myPm10
                  myItem.dPm10Cai = myPm10Cai
                  myItem.dSite = mySite
                  items.append(myItem)
            }
      }
}

