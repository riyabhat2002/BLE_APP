//
//  DashboardViewController.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.
//

import UIKit
import CoreBluetooth

extension Notification.Name {
    static let didReceiveTemperatureData = Notification.Name("didReceiveTemperature")
    static let didReceiveHumidityData = Notification.Name("didReceiveHumidity")
    static let didReceiveSoilMoistureData = Notification.Name("didReceiveSoilMoisture")
    static let didReceiveLightMode = Notification.Name("didReceiveLightMode")
    static let didReceiveLightStatus = Notification.Name("didReceiveLightStatus")
}

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
                if let humidity = value.toUInt32AsInt() {
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
