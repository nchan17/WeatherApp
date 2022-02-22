//
//  ForecastFiveViewController.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import Foundation
import UIKit

class ForecastFiveViewController: UIViewController, ErrorViewDelegate{
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var errorView: ErrorView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    var topInset :CGFloat = 0;
    private let service = Service()
    private var fullSortedForecast = [DayForecast]()
    
    var cityName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.isHidden = true
        tableView.backgroundColor = .clear
        
        errorView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ForecastFiveCell", bundle: nil),  forCellReuseIdentifier: "ForecastFiveCell")
        tableView.register(UINib(nibName: "ForecastFiveHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ForecastFiveHeader")
        loadChosenCityName()
        
        
    }
    
    func didPressRefreshButton(_ sender: ErrorView) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadChosenCityName()
    }
    
    private func loadChosenCityName(){
        cityName = TabBarSingleton.sharedInstance.city
        refresh()
    }
    
    @IBAction func refreshHandler(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    private func refresh(){
        if (cityName != nil) {
            loadForecastFive(cityName: cityName!)
        } else {
            showErrorScreen()
        }
    }
    
    func showErrorScreen() {
        self.errorView.isHidden = false
        self.view.bringSubviewToFront(self.errorView)
        self.tableView.isHidden = true
    }
    
    func hideErrorScreen() {
        self.errorView.isHidden = true
        self.tableView.isHidden = false
    }
    
    private func loadForecastFive(cityName: String){
        loader.startAnimating()
        service.loadForecastFive(cityName: cityName) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let forecastFive):
                        self.errorView.isHidden = true
                        self.tableView.isHidden = false
                        self.fullSortedForecast = self.getSortedForecast(forcastList: forecastFive)
                        self.tableView.reloadData()
                        self.loader.stopAnimating()
                    case .failure(let error):
                        self.errorView.isHidden = false
                        self.view.bringSubviewToFront(self.errorView)
                        self.tableView.isHidden = true
                        self.errorView.errorLabel?.text = error.localizedDescription
                        self.loader.stopAnimating()
                }
            }
        }
    }
    
    private func getSortedForecast(forcastList: [Forecast]) -> [DayForecast]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "EEEE"
                
        var fullForecast = [DayForecast]()
        for (i, forecast) in forcastList.enumerated() {
            let day :String = dateFormatter.string(from: Date(timeIntervalSince1970: forecast.dt)).uppercased()
            if (i == 0) {
                fullForecast.append(DayForecast(dayForecast: [forecast], weekDay: day))
            } else {
                let lastIndex = fullForecast.count - 1
                if (fullForecast[lastIndex].weekDay == day){
                    fullForecast[lastIndex].dayForecast.append(forecast)
                } else {
                    fullForecast.append(DayForecast(dayForecast: [forecast], weekDay: day))
                }
            }
            
        }
        return fullForecast
    }
}


extension ForecastFiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return fullSortedForecast.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullSortedForecast[section].dayForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastFiveCell", for: indexPath)
        cell.backgroundColor = .clear
        if let forecastFiveCell = cell as? ForecastFiveCell {
            let forecast = fullSortedForecast[indexPath.section].dayForecast[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            forecastFiveCell.timeLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: forecast.dt))
            
            forecastFiveCell.descLabel?.text = forecast.weather[0].description.capitalized
            forecastFiveCell.tempLabel?.text = String(Int(round(forecast.main.temp))) + "°C"
            forecastFiveCell.iconImage?.sd_setImage(with: service.getImgUrl(id: forecast.weather[0].icon))
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ForecastFiveHeader")
        header?.contentView.backgroundColor = UIColor(named: "bg-gradient-end")
        
        if let myHeader = header as? ForecastFiveHeader {
            myHeader.titleLabel?.text = fullSortedForecast[section].weekDay
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
}

