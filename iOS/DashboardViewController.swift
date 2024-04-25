//
//  DashboardViewController.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.
//

//import UIKit
//
//class DashboardViewController: UIViewController {
//
//    let temperatureLabel = createLabel(title: "Temperature: --")
//    let humidityLabel = createLabel(title: "Humidity: --")
//    let lightLabel = createLabel(title: "Light Exposure: --")
//    let appNameLabel = createLabel(title: "Plantd")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemBackground // Use system background for dark/light mode
//        setupSensorDisplay()
//    }
//
//    private func setupSensorDisplay() {
//        appNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold) // Make app name larger and bold
//        appNameLabel.textAlignment = .center // Center align the app name
//
//        let stackView = UIStackView(arrangedSubviews: [appNameLabel, temperatureLabel, humidityLabel, lightLabel])
//        stackView.axis = .vertical
//        stackView.distribution = .equalCentering
//        stackView.alignment = .center
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
//    static func createLabel(title: String) -> UILabel {
//        let label = UILabel()
//        label.text = title
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.textColor = .label // Use label color for dark/light mode
//        label.numberOfLines = 0
//        return label
//    }
//}

import UIKit
import CoreBluetooth

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}

class DashboardViewController: UIViewController {

    var temperatureLabel: UILabel!
    var humidityLabel: UILabel!
    var lightLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleBluetoothData(_:)), name: .didReceiveData, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        // Background color to make text easily readable
        view.backgroundColor = .white

        // Initialize labels
        temperatureLabel = createLabel(text: "Temperature: --")
        humidityLabel = createLabel(text: "Humidity: --")
        lightLabel = createLabel(text: "Light Exposure: --")

        // Stack view to organize labels vertically
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel, lightLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }

    @objc func handleBluetoothData(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        DispatchQueue.main.async {
            if let temperature = userInfo["temperature"] {
                self.temperatureLabel.text = "Temperature: \(temperature)°C"
            }
            if let humidity = userInfo["humidity"] {
                self.humidityLabel.text = "Humidity: \(humidity)%"
            }
            if let light = userInfo["light"] {
                self.lightLabel.text = "Light Exposure: \(light)"
            }
        }
    }
}
