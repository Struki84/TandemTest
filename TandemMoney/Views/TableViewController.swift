//
//  TableTableViewController.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 20/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import UIKit
import CoreLocation

protocol CitiesDelegate {
    func selected(city id: Int)
}

class TableViewController: UITableViewController, CitiesDelegate {

    @IBOutlet var cityName: UILabel!
    @IBOutlet var currentWeather: UILabel!
    @IBOutlet var currentTemp: UILabel!
    @IBOutlet var hourForecast: UICollectionView!
    
    @IBOutlet var day1: UILabel!
    @IBOutlet var day2: UILabel!
    @IBOutlet var day3: UILabel!
    @IBOutlet var day4: UILabel!
    @IBOutlet var day5: UILabel!
    
    @IBOutlet var day1Icon: UIImageView!
    @IBOutlet var day2Icon: UIImageView!
    @IBOutlet var day3Icon: UIImageView!
    @IBOutlet var day4Icon: UIImageView!
    @IBOutlet var day5Icon: UIImageView!
    
    @IBOutlet var day1TmpMax: UILabel!
    @IBOutlet var day2TmpMax: UILabel!
    @IBOutlet var day3TmpMax: UILabel!
    @IBOutlet var day4TmpMax: UILabel!
    @IBOutlet var day5TmpMax: UILabel!
    
    @IBOutlet var day1TmpMin: UILabel!
    @IBOutlet var day2TmpMin: UILabel!
    @IBOutlet var day3TmpMin: UILabel!
    @IBOutlet var day4TmpMin: UILabel!
    @IBOutlet var day5TmpMin: UILabel!
    
    var apiInterface = ApiInterface()
    var forecastData: Forecast?
    var uiElements: [[UIView]] = []
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestForecast(id: 6618983)
        
        hourForecast.delegate = self
        hourForecast.dataSource = self
        
        uiElements = [
            [day1, day1Icon, day1TmpMax, day1TmpMin],
            [day2, day2Icon, day2TmpMax, day2TmpMin],
            [day3, day3Icon, day3TmpMax, day3TmpMin],
            [day4, day4Icon, day4TmpMax, day4TmpMin],
            [day5, day5Icon, day5TmpMax, day5TmpMin],
        ]
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCitySegue" {
            let destinationVC = segue.destination as? CitiesTableViewController
            destinationVC?.delegate = self
        }
    }

    func requestForecast(id: Int) {
        let city = "\(id)"
        apiInterface.get(forecastFor: city).response { (responseData) in
            switch responseData.status {
            case .success:
                self.forecastData = responseData.data as? Forecast
                DispatchQueue.main.async {
                    self.loadData()
                }
                debug.printApi(data: self.forecastData!, suspend: true)
            case .failure:
                debug.printApiError(error: responseData.error!)
            }
        }
    }
    
    func loadData() {
        let currentWeather = self.forecastData!.list![0]
        let tempInC = round(currentWeather.main!.temp! - 273)
        
        self.cityName.text = "City of \(self.forecastData!.city!.name!)"
        self.currentWeather.text = currentWeather.weather![0].main!
        self.currentTemp.text = "\(tempInC)˚"
        
        self.hourForecast.reloadData()
        
        self.loadForecastData()
        
    }
    
    func sortData() -> [[Forecast.ListItem]] {
        var sorted: [[Forecast.ListItem]] = []
        
        for i in 0..<5 {
            var sortedItems: [Forecast.ListItem] = []
            for item in forecastData!.list! {
                let timestamp = TimeInterval(Double(item.timestamp!))
                let itemDate = Date(timeIntervalSince1970: timestamp)
                let dateToForecast = Calendar.current.date(byAdding: .day, value: i, to: Date())
                if Calendar.current.isDate(itemDate, inSameDayAs: dateToForecast!) {
                    sortedItems.append(item)
                }
            }
            sorted.append(sortedItems)
        }
        return sorted
    }
    
    func loadForecastData() {
        for i in 0..<sortData().count {
            let dayLabel = uiElements[i][0] as! UILabel
            let dayIcon = uiElements[i][1] as! UIImageView
            let dayTmpMax = uiElements[i][2] as! UILabel
            let dayTmpMin = uiElements[i][3] as! UILabel
            let formatter = DateFormatter()
            let weatherData = sortData()[i]
            let date = Date(timeIntervalSince1970: TimeInterval(Double(weatherData[0].timestamp!)))
            let tmpMax = round(weatherData[0].main!.tempMax! - 273)
            let tmpMin = round(weatherData[0].main!.tempMin! - 273)
            let weatherIcon = weatherData[0].weather![0].icon
            
            formatter.dateFormat = "EEEE"
            
            dayLabel.text = formatter.string(from: date)
            dayTmpMax.text = "\(tmpMax)˚"
            dayTmpMin.text = "\(tmpMin)˚"
            
            apiInterface.getIcon(with: weatherIcon!).response(data: { (responseData) in
                if let imgData = responseData.rawData {
                    DispatchQueue.main.async {
                        dayIcon.image = UIImage(data: imgData)
                    }
                }
            })
        }
    }
    
    func loadCurrentCity(location: CLLocation) {
        if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                var cities = try decoder.decode([City].self, from: data)
                
            }
            catch let error {
                print("Cities list decoding error: \(error)")
            }
        }   
    }
    
    func selected(city id: Int) {
        requestForecast(id: id)
    }
}

//Mark: Delegates - UICollectionViewDelegate, UICollectionViewDataSource
extension TableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = forecastData {
            if let weatherList = data.list {
                return weatherList.count
            }
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourForecastCell", for: indexPath) as! CollectionViewCell
        let index = indexPath.row
        
        if let data = forecastData {
            if let weatherList = data.list {
                let item = weatherList[index]
                
                apiInterface.getIcon(with: item.weather![0].icon!).response(data: { (responseData) in
                    if let imgData = responseData.rawData {
                        DispatchQueue.main.async {
                            cell.icon.image = UIImage(data: imgData)
                        }
                    }
                })
                    
                let temp = round(item.main!.temp! - 273)
                cell.temp.text = "\(temp)"
                
                let timeFormat = DateFormatter()
                timeFormat.dateFormat = "HH"
                
                let date = Date(timeIntervalSince1970: TimeInterval(item.timestamp!))
                cell.time.text = timeFormat.string(from: date)
            }
        }
        
        return cell
    }
}

//Maek: - Delegates

extension TableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        loadCurrentCity(location: locations.first!)
    }
}
