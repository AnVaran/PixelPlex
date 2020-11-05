//
//  ViewController.swift
//  Pixel
//
//  Created by Admin on 03.11.2020.
//

import UIKit
import CoreLocation

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    private var rssItems: [RSSItem]?
    let file = "file.txt"
    var fileData = ""
    
    let locationManader = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        checkUserLocation()
        settingCollecctioView()
        fetchDatafromFile()
        fetchData()
    }
    
    private func settingCollecctioView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1843137255, blue: 0.2549019608, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isHidden = true
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func checkUserLocation() {

        locationManader.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManader.delegate = self
            locationManader.desiredAccuracy = kCLLocationAccuracyBest
            locationManader.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { (placemark, error) in
                if error == nil {
                    guard let placemark = placemark?.last else { return }
                    
                    self.hiddenFeed(from: placemark)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            showGeolocateAlert()
        }
    }
    
    private func showCanselAlert() {
        let alertController = UIAlertController(title: "Нет доступа", message: "К сожалению данное приложение работает только в Беларуси.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showGeolocateAlert() {
        let alertController = UIAlertController(title: "Нет доступа", message: "К сожалению данное приложение работает c геолокицией", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func hiddenFeed(from placemark: CLPlacemark) {
        if let country = placemark.country {
            if country == "Belarus" {
                collectionView.isHidden = false
            } else {
                showCanselAlert()
                locationManader.stopUpdatingLocation()
                locationManader.delegate = nil
            }
        }
    }
    
    private func fetchDatafromFile() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)
            //reading
            do {
                fileData = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch (let error){
                print(error)
            }
        }
    }
    
    private func fetchData() {
        let feedLoad = FeedLoad()
        if Reachability.isConnectedToNetwork(){
            feedLoad.loadFeed(url: "https://news.tut.by/rss/all.rss") { (rssItems) in
                self.rssItems = rssItems
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        } else {
            let data = Data(fileData.utf8)
            _ = Parser(data: data) { (rssItems) in
                self.rssItems = rssItems
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //print(view.frame.height)
        
        return CGSize(width: view.frame.width - 60, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FeedCell
        if let item = rssItems?[indexPath.item] {
            cell.item = item
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(identifier: "detailCollectionController") as! DetailCollectionController
        if let item = rssItems?[indexPath.item] {
            detailViewController.rssItem = item
        }
        
        self.present(detailViewController, animated: true, completion: nil)
    }
}


