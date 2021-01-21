//
//  ViewController.swift
//  IOSWeatherApp
//
//  Created by Ethan Majidi on 2020-08-16.
//  Copyright © 2020 Ethan Majidi. All rights reserved.
//

import UIKit
import CoreLocation



//custome cell : collection view

//API 

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var table: UITableView!
    var models = [CurrentWeather]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //Register 2 cells (order of registering cells does not matter if you register before use)
//        table.register(HourlyTableViewCell.nib(), forHeaderFooterViewReuseIdentifier: HourlyTableViewCell.identifier)
//        table.register(WeatherTableViewCell.nib(), forHeaderFooterViewReuseIdentifier: WeatherTableViewCell.identifier)
//        table.delegate = self
//        table.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    //Location
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else{
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=c7fe65dd23bb08100043a2ce9341647a"
        
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            //validationCurrentDescription
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            
            //Convert data to models/some objects
            var json: WeatherResponse?
            do{
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch{
                print("error!!!: \(error)")
            }
            
            guard let result = json else{
                return
            }
        
            
            
            //Update user interface
            DispatchQueue.main.async {
                //Location Lble
                let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
                label.textAlignment = .center
                label.text = result.name
                label.font = .systemFont(ofSize: 40)
//                label.backgroundColor = .red
                self.view.addSubview(label)
                
                
                //conditons label
                let conditionsLabel = UILabel(frame: CGRect(x: 100, y: 500, width:200, height: 100))
                conditionsLabel.textAlignment = .center
                conditionsLabel.text = result.weather[0].description
                conditionsLabel.font = .systemFont(ofSize: 20)
//                conditionsLabel.backgroundColor = .red
                self.view.addSubview(conditionsLabel)
                
                //Temp label
                let tempLabel = UILabel(frame: CGRect(x: 100, y: 550, width:200, height: 100))
                tempLabel.textAlignment = .center
//                var temp:Float = result.main.temp
//                temp = temp - 273.15
//                tempLabel.text = temp
                let temp:String = String(format: "%.0f", result.main.temp - 273.15)
                tempLabel.text = temp + "c"
                tempLabel.font = .systemFont(ofSize: 40)
                //conditionsLabel.backgroundColor = .red
                self.view.addSubview(tempLabel)
                
                //Icon/background
//                let date = Date()
//                let calendar = Calendar.current
//                let hour = calendar.component(.hour, from: date)
                //icon for day clear
                
                let imageView : UIImageView
                imageView = UIImageView(frame: CGRect(x: 50, y: 200, width: 300, height: 300))
                
                //icon for clear day
                if result.weather[0].icon == "01d"{
                    imageView.image = UIImage(named: "Sunny")
                }
                //icon for night clear
                else if result.weather[0].icon == "01n"{
                    imageView.image = UIImage(named: "Moon")
                }
                //icons for cloudy
                else if result.weather[0].icon == "02d" || result.weather[0].icon == "02n" || result.weather[0].icon == "03d" || result.weather[0].icon == "03n" || result.weather[0].icon == "04d" || result.weather[0].icon == "04n" {
                    imageView.image = UIImage(named: "Cloudy")
                }
                //icon raining
                else if result.weather[0].icon == "09d" || result.weather[0].icon == "09n" || result.weather[0].icon == "10d" || result.weather[0].icon == "10n" {
                    imageView.image = UIImage(named: "Rainy")
                }
                //icon for thunder
                else if result.weather[0].icon == "11n" || result.weather[0].icon == "11n" {
                    imageView.image = UIImage(named: "Thundery")
                }
                //icon for snow
                else if result.weather[0].icon == "13n" || result.weather[0].icon == "11n" {
                    imageView.image = UIImage(named: "Snowy")
                }
                //icon for mist
                else if result.weather[0].icon == "50d" || result.weather[0].icon == "50n" {
                    imageView.image = UIImage(named: "Misty")
                }
                self.view.addSubview(imageView)
                
                
                
            }
            
        }.resume()
    }
    
    //table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}

struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [CurrentWeather]
    let base: String
    let main: CurrentMain
    let wind: CurrentWind
    let clouds: CurrentClouds
    let dt: Int
    let sys: System
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}


struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}
struct CurrentWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct CurrentMain: Codable {
    let temp: Float
    let pressure: Double
    let humidity: Int
    let temp_min: Float
    let temp_max: Float
}
struct CurrentWind: Codable {
    let speed: Double
    let deg: Int
}

struct CurrentClouds: Codable {
    let all: Int
}
struct System: Codable {
    
    let country: String
    let sunrise: Int
    let sunset: Int
}
