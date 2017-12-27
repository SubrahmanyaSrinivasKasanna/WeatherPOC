//
//  ViewController.swift
//  WeatherApp
//
//  Created by Srinivas Kasanna on 12/26/17.
//  Copyright © 2017 asdf. All rights reserved.
//

import UIKit

/***
 //MVC design Pattern
 Weather view controller follows MVC design pattern by tightly coupling the Model and View.
 This Contoller performs all the high level operatios include triggering the requestes to fetch all the weather information and map reponse to the model object
 ***/

/***
 I chhosen seach bar to get the City as input from user beacuse it's easy to implement. We have many different ways to get the same behaivour but as per time cinstarints I choosen search bar as easiet to implement.
 
 I choosen USERDEFAULTS to store the last save search instead of PLIST, CoreData or any database. The main reason is the data size is very small, and have to store only one record.
 
  I have included the service test cases but Still there is a huge scope of implementing the testcases. I would more concentrate on XCUITESTCASE to automate my project. It's obvious to implement UI automate test framework
 
 ***/

class WeatherViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var weatherSearchBar: UISearchBar!
    lazy var persistLastSearch: UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var temparature: UILabel!
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var weatherInfoResponse: WeatherDataModel?
    
    let imageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "theme")
        iv.image = image
        return iv
    }()
    
    //Making sure not to create the object until it's first time use..
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        return ac
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        weatherSearchBar.placeholder = ENTER_CITY_PLACEHOLDER_TEXT
        weatherSearchBar.delegate = self
        self.view.addSubview(activityIndicator)
        self.addConstraints()
        self.showWeatherDataToView(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SerachBar Delegate Methods
   
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        let url = WeatherUtils.searchURLByCity(city: searchBar.text ?? "")
        getWeatherDetails(url: url!)
    }
    
    // MARK: - Helper methods
    
    func addConstraints() {
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
    /**
     To invoke web service call to get the weather details for the given city.
     - parameter url: Request url to get the weather details
     */
    func getWeatherDetails(url: URL){
        self.activityIndicator.startAnimating()

        WebServiceManager.getWeatherData(requestURL: url) { (object, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let error = error{
                WeatherUtils.showAlert(controller: self, title: ERROR, message: error.localizedDescription)
            }
            if object != nil{
                do {
                    if let json = try JSONSerialization.jsonObject(with: object as! Data, options: .allowFragments) as? [String: Any]
                    {
                        
                        self.weatherInfoResponse = WeatherDataModel(json:json as JSON)
                        if let responseCode = json["cod"] as? String, responseCode == "404" {
                            WeatherUtils.showAlert(controller: self, title: ERROR, message: (json["message"] as? String) ?? "Failed to retrive weather data" )

                        }
                        DispatchQueue.main.async {
                            guard let  weather = self.weatherInfoResponse?.weather, weather.count > 0 else { return }
                            let url = WeatherUtils.urlForIcon(iconString: weather[0].icon)
                            WebServiceManager.getWeatherInformation(url: url) { [unowned self](resultData) in
                                DispatchQueue.main.async { [unowned self] in
                                    guard let image = UIImage(data: resultData) else { return }
                                    self.weatherInfoResponse?.imageIcon = image
                                    self.showWeatherDataToView(self.weatherInfoResponse)
                                }
                            }
                        }
                       
                    }
                } catch {
                    DispatchQueue.main.async {
                        WeatherUtils.showAlert(controller: self, title: ALERT, message: NO_WEATHER_INFO_FOUND)
                    }
                }
            }
    }

    }
    
    /**
     To populate the weather info in the view
     - parameter data: Weather details from reponse
     */
    func showWeatherDataToView(_ data: WeatherDataModel?){
            if self.cityName != nil {
                if let cityName = data?.name {
                    self.cityName.text = cityName
                    persistLastSearch.set(cityName, forKey: CITY_NAME)
                } else if let cityName = persistLastSearch.value(forKey: CITY_NAME) {
                    self.cityName.text = cityName as? String ?? ""
                }
            }
            if self.weatherStatus != nil {
                if let weather = data?.weather, weather.count > 0, let mainStatus = weather[0].main{
                    self.weatherStatus.text = mainStatus
                    persistLastSearch.set(mainStatus, forKey: "weather")
                } else if let weather = persistLastSearch.value(forKey: "weather") {
                    self.weatherStatus.text = weather as? String ?? ""
                }
            }
            if self.temparature != nil {
                if let temp = data?.main?.temp {
                    self.temparature.text = getConvertedTemp(temp: temp)
                    persistLastSearch.set(temp, forKey: "temp")
                } else if let temp = persistLastSearch.value(forKey: "temp") {
                    if let temp = temp as? NSNumber {
                        self.temparature.text = getConvertedTemp(temp: temp)
                    }
                    
                }
            }
            if self.todayLabel != nil {
                todayLabel.text = "Today"
            }
            if self.dayName != nil {
                if let weekDayName = data?.weekDayName {
                    self.todayLabel.isHidden = false
                    self.dayName.text = weekDayName
                    persistLastSearch.set(weekDayName, forKey: "weekDayName")
                } else if let weekDayName = persistLastSearch.value(forKey: "weekDayName") {
                    self.dayName.text = weekDayName as? String ?? ""
                    self.todayLabel.isHidden = false
                }
            }
            if self.minTemp != nil {
                if let temp = data?.main?.temp_min {
                    self.minTemp.text = getConvertedTemp(temp: temp)
                    persistLastSearch.set(temp, forKey: "temp_min")
                } else if let temp = persistLastSearch.value(forKey: "temp_min") {
                    if let temp = temp as? NSNumber {
                        self.minTemp.text = getConvertedTemp(temp: temp)
                    }
                }
            }
        
        if self.maxTemp != nil {
            if let temp = data?.main?.temp_max {
                self.maxTemp.text = getConvertedTemp(temp: temp)
                persistLastSearch.set(temp, forKey: "temp_max")
            } else if let temp = persistLastSearch.value(forKey: "temp_max") {
                if let temp = temp as? NSNumber {
                    self.maxTemp.text = getConvertedTemp(temp: temp)
                }
            }
        }
      
            if self.weatherIcon != nil {
                if let image = data?.imageIcon {
                    self.weatherIcon.image = image
                    self.weatherIcon.translatesAutoresizingMaskIntoConstraints = false
                    self.weatherIcon.tintColor = UIColor(white: 1, alpha: 0.4)
                    ///               While it is possible to save a UIImage to NSUserDefaults, it is often not recommended as it is not        the most efficient way to save images; a more efficient way is to save your image in the application's Documents Directory
                    ///
                    persistLastSearch.set(UIImagePNGRepresentation(image), forKey: "imageIcon")
                }else if let imageData = persistLastSearch.object(forKey: "imageIcon") ,
                    let image = UIImage(data: imageData as! Data){
                    self.weatherIcon.image = image
                    self.weatherIcon.translatesAutoresizingMaskIntoConstraints = false
                    self.weatherIcon.tintColor = UIColor(white: 1, alpha: 0.4)
                }
            }
    }
    
    /**
     To convert temprature to Celcius
     - parameter temp: temprature
     - returns: temprature in Celcius
     */
    func getConvertedTemp(temp: NSNumber) -> String {
        let tempKelvin = Double(truncating: temp)
        let tempCelcius = Int(tempKelvin - 273.15)
        let k = NSString(format:"\(tempCelcius)%@" as NSString, "\u{00B0}") as String
        return k
    }
    
}

