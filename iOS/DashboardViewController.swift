//
//  DashboardViewController.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.
//

//import UIKit
//import CoreBluetooth
//
//extension Notification.Name {
//    static let didReceiveTemperatureData = Notification.Name("didReceiveTemperature")
//    static let didReceiveHumidityData = Notification.Name("didReceiveHumidity")
//    static let didReceiveLightMode = Notification.Name("didReceiveLightMode")
//    static let didReceiveLightStatus = Notification.Name("didReceiveLightStatus")
//}
//
//class DashboardViewController: UIViewController {
//    var temperatureLabel: UILabel!
//    var humidityLabel: UILabel!
//    var lightLabel: UILabel!
//    var lightModeLabel: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        registerForNotifications()
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        temperatureLabel = createLabel(text: "Temperature: --")
//        humidityLabel = createLabel(text: "Humidity: --")
//        lightLabel = createLabel(text: "Light Exposure: Off")
//        lightModeLabel = createLabel(text: "Light Mode: Manual")
//
//        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel, lightLabel, lightModeLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        stackView.distribution = .fillEqually
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
//        ])
//    }
//
//    private func createLabel(text: String) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 20)
//        return label
//    }
//
//    private func registerForNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(updateTemperature(_:)), name: .didReceiveTemperatureData, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateHumidity(_:)), name: .didReceiveHumidityData, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateLightMode(_:)), name: .didReceiveLightMode, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateLightStatus(_:)), name: .didReceiveLightStatus, object: nil)
//    }
//
//    @objc func updateTemperature(_ notification: Notification) {
//        if let temperature = notification.userInfo?["temperature"] as? Float {
//            DispatchQueue.main.async {
//                self.temperatureLabel.text = "Temperature: \(temperature)°C"
//            }
//        }
//    }
//
//    @objc func updateHumidity(_ notification: Notification) {
//        if let humidity = notification.userInfo?["humidity"] as? Float {
//            DispatchQueue.main.async {
//                self.humidityLabel.text = "Humidity: \(humidity)%"
//            }
//        }
//    }
//
//    @objc func updateLightMode(_ notification: Notification) {
//        if let mode = notification.userInfo?["mode"] as? String {
//            DispatchQueue.main.async {
//                self.lightModeLabel.text = "Light Mode: \(mode)"
//            }
//        }
//    }
//
//    @objc func updateLightStatus(_ notification: Notification) {
//        if let status = notification.userInfo?["status"] as? String {
//            DispatchQueue.main.async {
//                self.lightLabel.text = "Light Exposure: \(status)"
//            }
//        }
//    }
//}

import UIKit
import CoreBluetooth

extension Notification.Name {
    static let didReceiveTemperatureData = Notification.Name("didReceiveTemperature")
    static let didReceiveHumidityData = Notification.Name("didReceiveHumidity")
    static let didReceiveSoilMoistureData = Notification.Name("didReceiveSoilMoisture")
    static let didReceiveLightMode = Notification.Name("didReceiveLightMode")
    static let didReceiveLightStatus = Notification.Name("didReceiveLightStatus")
}

//class DashboardViewController: UIViewController, BluetoothManagerDelegate {
//    var temperatureLabel: UILabel!
//    var humidityLabel: UILabel!
//    var soilMoistureLabel: UILabel!  // Label for soil moisture
//    var lightLabel: UILabel!
//    var lightModeLabel: UILabel!
//    var bluetoothManager: BluetoothManager?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        registerForNotifications()
//        bluetoothManager?.delegate = self
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        temperatureLabel = createLabel(text: "Temperature: --")
//        humidityLabel = createLabel(text: "Humidity: --")
//        soilMoistureLabel = createLabel(text: "Soil Moisture: --")  // Initialize the soil moisture label
//        lightLabel = createLabel(text: "Light Exposure: Off")
//        lightModeLabel = createLabel(text: "Light Mode: Manual")
//
//        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel, soilMoistureLabel, lightLabel, lightModeLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        stackView.distribution = .fillEqually
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
//        ])
//    }
//
//    private func createLabel(text: String) -> UILabel {
//        let label = UILabel()
//        label.text = text
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 20)
//        return label
//    }
//
//    private func registerForNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateTemperature(_:)), name: .didReceiveTemperatureData, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateHumidity(_:)), name: .didReceiveHumidityData, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateSoilMoisture(_:)), name: .didReceiveSoilMoistureData, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateLightMode(_:)), name: .didReceiveLightMode, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateLightStatus(_:)), name: .didReceiveLightStatus, object: nil)
//    }
//
//    @objc func didUpdateTemperature(_ temperature: Float) {
//        DispatchQueue.main.async {
//            self.temperatureLabel.text = "Temperature: \(temperature)°C"
//        }
//    }
//
//    @objc func didUpdateHumidity(_ humidity: Int) {
//        DispatchQueue.main.async {
//            self.humidityLabel.text = "Humidity: \(humidity)%"
//        }
//    }
//
//    @objc func didUpdateSoilMoisture(_ moisture: Float) {
//        DispatchQueue.main.async {
//            self.soilMoistureLabel.text = "Soil Moisture: \(moisture)"
//        }
//    }
//
//    @objc func updateLightMode(_ notification: Notification) {
//        if let mode = notification.userInfo?["mode"] as? String {
//            DispatchQueue.main.async {
//                self.lightModeLabel.text = "Light Mode: \(mode)"
//            }
//        }
//    }
//
//    @objc func updateLightStatus(_ notification: Notification) {
//        if let status = notification.userInfo?["status"] as? String {
//            DispatchQueue.main.async {
//                self.lightLabel.text = "Light Exposure: \(status)"
//            }
//        }
//    }
//}

class DashboardViewController: UIViewController, BluetoothManagerDelegate {
    var temperatureLabel: UILabel!
    var humidityLabel: UILabel!
    var soilMoistureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        BluetoothManager.shared.delegate = self
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        temperatureLabel = createLabel(text: "Temperature: --")
        humidityLabel = createLabel(text: "Humidity: --")
        soilMoistureLabel = createLabel(text: "Soil Moisture: --")

        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel, soilMoistureLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

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
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }

    // MARK: - BluetoothManagerDelegate Methods

    func didUpdateTemperature(_ temperature: Float) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "Temperature: \(temperature)°C"
        }
    }

    func didUpdateHumidity(_ humidity: Int) {
        DispatchQueue.main.async {
            self.humidityLabel.text = "Humidity: \(humidity)%"
        }
    }

    func didUpdateSoilMoisture(_ moisture: Float) {
        DispatchQueue.main.async {
            self.soilMoistureLabel.text = "Soil Moisture: \(moisture)"
        }
    }

    func didUpdateValue(for characteristic: CBCharacteristic, value: Data?) {
        guard let value = value else { return }
        DispatchQueue.main.async {
            switch characteristic.uuid {
            case CBUUID(string: "FC5031E4-1D63-4038-AEB7-6A3B20D7740C"):
                if let temperature = value.toFloatLittleEndian() {
                    self.didUpdateTemperature(temperature)
                }
            case CBUUID(string: "2E75A5DD-A42B-420A-B9AB-3F15E19AE0EE"):
                if let humidity = value.toInt() {
                    self.didUpdateHumidity(humidity)
                }
            case CBUUID(string: "2CA77EE6-AFFB-48FD-BA94-2E0745B36A3D"):
                if let moisture = value.toFloatLittleEndian() {
                    self.didUpdateSoilMoisture(moisture)
                }
            default:
                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
            }
        }
    }

    func didWriteValue(for characteristic: CBCharacteristic) {
        print("Value written to \(characteristic.uuid)")
    }
}
