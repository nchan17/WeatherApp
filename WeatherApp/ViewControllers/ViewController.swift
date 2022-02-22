//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/5/21.
//

import UIKit
import CoreLocation
import SDWebImage
import CollectionViewPagingLayout
import UPCarouselFlowLayout
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, AddCityDelegate, ErrorViewDelegate {
    
    @IBOutlet var errorView: ErrorView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var addCityDialog: AddCityDialog!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorDialog: ErrorDialog!
    
    private var fullCurrentWeather = [CurrentWeatherResponse]()
    private let service = Service()
    
    private let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
    private let colors = [UIColor(named: "green-gradient-end")?.cgColor,
                          UIColor(named: "ochre-gradient-start")?.cgColor,
                          UIColor(named: "blue-gradient-end")?.cgColor]
    
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private let group = DispatchGroup()
    private let queue = DispatchQueue(label: "serial")
    private var userDefaults = UserDefaults.standard
    private var isError = true
    private let blurrEffectView = UIVisualEffectView?.self
    
    private var allCities = [String]()
        
    let flowLayout = CollectionViewPagingLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.isHidden = true
        addCityDialog.delegate = self
        errorView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let newFlowLayout = UPCarouselFlowLayout()
        newFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: collectionView.frame.size.height)

        newFlowLayout.scrollDirection = .horizontal
        newFlowLayout.sideItemScale = 0.9
        newFlowLayout.sideItemAlpha = 1.0

        newFlowLayout.spacingMode = .fixed(spacing: 20.0)
        collectionView.collectionViewLayout = newFlowLayout
        
        
        collectionView.register(UINib(nibName: "CurrentWeatherCell", bundle: nil), forCellWithReuseIdentifier: "CurrentWeatherCell")
        collectionView.isPagingEnabled = true
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:))))
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if (!addCityDialog.isHidden){
            let touch: UITouch? = touches.first
            if touch?.view != addCityDialog {
                hideAddCityDialog()
                hideErrorDialog()
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(
            location,
            completionHandler: { placemarks, error in
                guard error == nil,
                    let placemark = placemarks?[0]
                else {
                    self.showErrorScreen()
                    return
                }
                let city : String? = placemark.locality
                if (city != nil){
                    self.allCities.append(city!)
                    var list = self.getSavedListDefaults()
                    let searchRes = list.firstIndex(of: city!)
                    if (searchRes != nil) {
                        list.remove(at: searchRes!)
                    }
                    self.allCities.append(contentsOf: list)
                    self.loadCurrentWeathers(cityNames: self.allCities)
                } else {
                    self.showErrorScreen()
                }
            }
        )
    }
    
    func showErrorScreen() {
        self.errorView.isHidden = false
        self.view.bringSubviewToFront(self.errorView)
        self.collectionView.isHidden = true
    }
    
    func hideErrorScreen() {
        self.errorView.isHidden = true
        self.collectionView.isHidden = false
    }
    
    func showAddCityDialog() {
        let blurrEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurrEffectView = UIVisualEffectView(effect: blurrEffect)
        blurrEffectView.frame = view.bounds
        blurrEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurrEffectView)
        self.view.addSubview(self.addCityDialog)
        self.addCityDialog.isHidden = false
        self.view.bringSubviewToFront(self.addCityDialog)
    }
    
    func hideAddCityDialog(){
        self.addCityDialog.isHidden = true
        for subView in self.view.subviews {
            if subView is UIVisualEffectView {
                subView.removeFromSuperview()
            }
        }
    }
    
    func showErrorDialog(){
        self.view.addSubview(self.errorDialog)
        self.errorDialog.isHidden = false
        self.view.bringSubviewToFront(self.errorDialog)
    }
    
    func hideErrorDialog(){
        self.errorDialog.isHidden = true
        for subView in self.view.subviews {
            if subView is UIVisualEffectView {
                subView.removeFromSuperview()
            }
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            //  swori qalaqi unda wavshalo
            deleteItem(at: indexPath)
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        if (self.presentedViewController == nil) {
            let message = "City will be deleted"
            let alert = UIAlertController(title: "Delete City?", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] _ in
                print(indexPath.row)
                
                var index = 0
                if(TabBarSingleton.sharedInstance.city != nil){
                    index = allCities.firstIndex(of: TabBarSingleton.sharedInstance.city!) ?? 0
                }
                allCities.remove(at: index)
                saveListDefaults(list: allCities)
                fullCurrentWeather.removeAll()
                allCities.removeAll()
                locationManager.startUpdatingLocation()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func saveListDefaults(list: [String]){
        userDefaults.set(list, forKey: "SavedList")
    }
    
    func getSavedListDefaults() -> [String] {
        return self.userDefaults.object(forKey: "SavedList") as? [String] ?? [String]()
    }
    
    @IBAction func refreshHandler(_ sender: UIBarButtonItem) {
        fullCurrentWeather.removeAll()
        allCities.removeAll()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func addCityMainButtonPressed(){
        showAddCityDialog()
    }
    
    private func loadCurrentWeathers(cityNames : [String]){
        isError = false
        for currCity in cityNames {
            loader.startAnimating()
            self.view.bringSubviewToFront(self.loader)
            group.enter()
            queue.async() {
                self.service.loadCurrentWeather(cityName: currCity) { [weak self] result in
                guard let self = self else { return }
                
                    switch result {
                        case .success(let currentWeather):
                            self.fullCurrentWeather.append(currentWeather)
                            self.group.leave()
                        case .failure:
                            self.isError = true
                            self.group.leave()
                    }
                
                }
            }
        }
        group.notify(queue: DispatchQueue.main){
            self.loader.stopAnimating()
            if(self.fullCurrentWeather.count > 0){
                TabBarSingleton.sharedInstance.city = self.fullCurrentWeather[0].name
            }
            
            if (self.isError) {
                self.showErrorScreen()
            } else {
                self.hideErrorScreen()
                self.allCities.removeAll()
                for myCity in self.fullCurrentWeather {
                    self.allCities.append(myCity.name)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadNewCityCurrentWeathers(cityNames : [String]){
        isError = false
        for currCity in cityNames {
            loader.startAnimating()
            self.view.bringSubviewToFront(self.loader)
            group.enter()
            queue.async() {
                self.service.loadCurrentWeather(cityName: currCity) { [weak self] result in
                guard let self = self else { return }
                
                    switch result {
                        case .success(let currentWeather):
                            self.fullCurrentWeather.append(currentWeather)
                            self.group.leave()
                        case .failure:
                            self.isError = true
                            self.group.leave()
                    }
                
                }
            }
        }
        group.notify(queue: DispatchQueue.main){
            self.loader.stopAnimating()
            
            if (self.isError) {
                self.showErrorDialog()
            } else {
                self.addCityDialog.textField?.text = ""
                self.hideErrorDialog()
                self.hideAddCityDialog()
                self.allCities.insert(cityNames[0], at: 0)
                self.saveListDefaults(list: self.allCities)
                self.collectionView.reloadData()
            }
        }
    }
    func didPressAddCityButton(_ sender: AddCityDialog){
        let newCity = addCityDialog.textField?.text
        addCityDialog.textField?.text? = ""
        if(newCity != nil && !newCity!.isEmpty){
            fullCurrentWeather.removeAll()
            var potentialAllCities = allCities
            potentialAllCities.insert(newCity!, at: 0)
            self.loadNewCityCurrentWeathers(cityNames: potentialAllCities)
        }
        
    }
    
    func didPressRefreshButton(_ sender: ErrorView) {
        fullCurrentWeather.removeAll()
        allCities.removeAll()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate var pageSize: CGSize {
            let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
            var pageSize = layout.itemSize
            if layout.scrollDirection == .horizontal {
                pageSize.width += layout.minimumLineSpacing
            } else {
                pageSize.height += layout.minimumLineSpacing
            }
            return pageSize
        }
    
}


extension ViewController : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        let currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        TabBarSingleton.sharedInstance.city = fullCurrentWeather[currentPage].name
        print("current page is " + TabBarSingleton.sharedInstance.city!)
    }
    
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fullCurrentWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentWeatherCell", for: indexPath)
        print(indexPath.row)
        let currentWeather = fullCurrentWeather[indexPath.row]
        
        if let currentWeatherCell = cell as? CurrentWeatherCell {
            currentWeatherCell.layer.backgroundColor = colors[indexPath.row % 3]            
            currentWeatherCell.cityLabel?.text = currentWeather.name + ", " + currentWeather.sys.country
            currentWeatherCell.cityDescriptionLabel?.text = String(Int(round(currentWeather.main.temp))) + "°C | " + currentWeather.weather[0].description.capitalized
            currentWeatherCell.cloudinessLabel?.text = String(currentWeather.clouds.all) + " %"
            currentWeatherCell.humidityLabel?.text = String(currentWeather.main.humidity) + " mm"
            currentWeatherCell.windSpeedLabel?.text = String(currentWeather.wind.speed) + " km/h"
            currentWeatherCell.windDirectionLabel?.text = String(directions[Int((Double(currentWeather.wind.deg) + 22.5) / 45.0) & 7])
        }
        
        return cell
    }
    
    
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: collectionView.frame.size.height)
    }
    
}

