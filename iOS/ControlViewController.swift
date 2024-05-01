////
////  ControlViewController.swift
////  BLEAPP
////
////  Created by Patron on 4/24/24.
//
//
//import UIKit
//
//class ControlViewController: UIViewController {
//
//    let temperatureSlider = createSlider()
//    let humiditySlider = createSlider()
//
//    let temperatureValueLabel = createValueLabel()
//    let humidityValueLabel = createValueLabel()
//
//    let lightModeSwitch = UISwitch()
//    let lightManualButton = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Control"
//        setupUI()
//        view.backgroundColor = UIColor.systemBackground // Use system background for dark/light mode
//    }
//
//    private func setupUI() {
//        let temperatureControl = createControl(with: temperatureSlider, valueLabel: temperatureValueLabel, title: "Temperature")
//        let humidityControl = createControl(with: humiditySlider, valueLabel: humidityValueLabel, title: "Humidity")
//        let lightControl = createLightControl()
//
//        let stackView = UIStackView(arrangedSubviews: [temperatureControl, humidityControl, lightControl])
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 20
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
//    private func createControl(with slider: UISlider, valueLabel: UILabel, title: String) -> UIStackView {
//        let titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.font = UIFont.systemFont(ofSize: 18)
//
//        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
//        
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, slider, valueLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 5
//
//        return stackView
//    }
//
//    private func createLightControl() -> UIStackView {
//        let switchLabel = UILabel()
//        switchLabel.text = "Automatic Light Mode"
//        switchLabel.font = UIFont.systemFont(ofSize: 16)
//
//        lightModeSwitch.addTarget(self, action: #selector(toggleLightMode(_:)), for: .valueChanged)
//        
//        lightManualButton.setTitle("Toggle Light Manually", for: .normal)
//        lightManualButton.backgroundColor = .systemBlue
//        lightManualButton.layer.cornerRadius = 5
//        lightManualButton.addTarget(self, action: #selector(toggleManualLight(_:)), for: .touchUpInside)
//
//        let stackView = UIStackView(arrangedSubviews: [switchLabel, lightModeSwitch, lightManualButton])
//        stackView.axis = .vertical
//        stackView.spacing = 5
//
//        return stackView
//    }
//
//    @objc private func toggleLightMode(_ sender: UISwitch) {
//        lightManualButton.isEnabled = !sender.isOn // Disable manual button when automatic mode is on
//    }
//
//    @objc private func toggleManualLight(_ sender: UIButton) {
//        // Handle manual light toggle logic here
//        print("Manual light toggle requested")
//    }
//
//    @objc func sliderValueChanged(_ sender: UISlider) {
//        let value = Int(sender.value)
//        switch sender {
//        case temperatureSlider:
//            temperatureValueLabel.text = "\(value)°C"
//        case humiditySlider:
//            humidityValueLabel.text = "\(value)%"
//        default:
//            break
//        }
//    }
//    
//    static func createSlider() -> UISlider {
//        let slider = UISlider()
//        slider.minimumValue = 0
//        slider.maximumValue = 100
//        slider.value = 50 // Default value
//        return slider
//    }
//    
//    static func createValueLabel() -> UILabel {
//        let label = UILabel()
//        label.text = "50" // Default value
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = .systemGray
//        label.textAlignment = .right
//        return label
//    }
//}


import UIKit
import CoreBluetooth

class ControlViewController: UIViewController {
    let lightSwitch = UISwitch()
    let fanSwitch = UISwitch()
    let motorSwitch = UISwitch()
    let mistingSystemSwitch = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Control"
        setupUI()
        view.backgroundColor = UIColor.systemBackground // Use system background for dark/light mode
    }

    private func setupUI() {
        lightSwitch.addTarget(self, action: #selector(toggleLight(_:)), for: .valueChanged)
        fanSwitch.addTarget(self, action: #selector(toggleFan(_:)), for: .valueChanged)
        motorSwitch.addTarget(self, action: #selector(toggleMotor(_:)), for: .valueChanged)
        mistingSystemSwitch.addTarget(self, action: #selector(toggleMistingSystem(_:)), for: .valueChanged)

        let stackView = UIStackView(arrangedSubviews: [createControl(with: lightSwitch, title: "Light"),
                                                       createControl(with: fanSwitch, title: "Fan"),
                                                       createControl(with: motorSwitch, title: "Motor"),
                                                       createControl(with: mistingSystemSwitch, title: "Misting System")])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createControl(with switch: UISwitch, title: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, `switch`])
        stackView.axis = .horizontal
        stackView.spacing = 10

        return stackView
    }

    @objc func toggleLight(_ sender: UISwitch) {
        writeValueToCharacteristic(value: sender.isOn ? 0 : 1, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
    }

    @objc func toggleFan(_ sender: UISwitch) {
        writeValueToCharacteristic(value: sender.isOn ? 4 : 5, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
    }

    @objc func toggleMotor(_ sender: UISwitch) {
        writeValueToCharacteristic(value: sender.isOn ? 6 : 7, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
    }

    @objc func toggleMistingSystem(_ sender: UISwitch) {
        writeValueToCharacteristic(value: sender.isOn ? 8 : 9, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
    }

    func writeValueToCharacteristic(value: Int, characteristicUUID: String) {
        guard let characteristic = findCharacteristic(by: CBUUID(string: characteristicUUID)) else {
            print("Characteristic not found")
            return
        }
        let data = Data([UInt8(value)])
        BluetoothManager.shared.writeControlValue(data: data)
    }

    func findCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
        // Implement a method to find the correct characteristic from BluetoothManager's connected peripheral.
        // This should retrieve the characteristic from the discovered characteristics of the connected peripheral.
        return BluetoothManager.shared.getCharacteristic(by: uuid)
    }
}
