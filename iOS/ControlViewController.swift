////
////  ControlViewController.swift
////  BLEAPP
////
////  Created by Patron on 4/24/24.
//
//import UIKit
//import CoreBluetooth
//
////class ControlViewController: UIViewController {
////    let lightSwitch = UISwitch()
////    let fanSwitch = UISwitch()
////    let motorSwitch = UISwitch()
////    let mistingSystemSwitch = UISwitch()
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        self.title = "Control"
////        setupUI()
////        view.backgroundColor = UIColor.systemBackground // Use system background for dark/light mode
////    }
////
////    private func setupUI() {
////        lightSwitch.addTarget(self, action: #selector(toggleLight(_:)), for: .valueChanged)
////        fanSwitch.addTarget(self, action: #selector(toggleFan(_:)), for: .valueChanged)
////        motorSwitch.addTarget(self, action: #selector(toggleMotor(_:)), for: .valueChanged)
////        mistingSystemSwitch.addTarget(self, action: #selector(toggleMistingSystem(_:)), for: .valueChanged)
////
////        let stackView = UIStackView(arrangedSubviews: [createControl(with: lightSwitch, title: "Light"),
////                                                       createControl(with: fanSwitch, title: "Fan"),
////                                                       createControl(with: motorSwitch, title: "Motor"),
////                                                       createControl(with: mistingSystemSwitch, title: "Misting System")])
////        stackView.axis = .vertical
////        stackView.distribution = .fillEqually
////        stackView.spacing = 20
////        stackView.translatesAutoresizingMaskIntoConstraints = false
////
////        view.addSubview(stackView)
////
////        NSLayoutConstraint.activate([
////            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
////            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
////            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
////        ])
////    }
////
////    private func createControl(with switch: UISwitch, title: String) -> UIStackView {
////        let titleLabel = UILabel()
////        titleLabel.text = title
////        titleLabel.font = UIFont.systemFont(ofSize: 18)
////
////        let stackView = UIStackView(arrangedSubviews: [titleLabel, `switch`])
////        stackView.axis = .horizontal
////        stackView.spacing = 10
////
////        return stackView
////    }
////
////    @objc func toggleLight(_ sender: UISwitch) {
////        writeValueToCharacteristic(value: sender.isOn ? 0 : 1, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
////    }
////
////    @objc func toggleFan(_ sender: UISwitch) {
////        writeValueToCharacteristic(value: sender.isOn ? 4 : 5, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
////    }
////
////    @objc func toggleMotor(_ sender: UISwitch) {
////        writeValueToCharacteristic(value: sender.isOn ? 6 : 7, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
////    }
////
////    @objc func toggleMistingSystem(_ sender: UISwitch) {
////        writeValueToCharacteristic(value: sender.isOn ? 8 : 9, characteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
////    }
////
////    func writeValueToCharacteristic(value: Int, characteristicUUID: String) {
////        guard let characteristic = findCharacteristic(by: CBUUID(string: characteristicUUID)) else {
////            print("Characteristic not found")
////            return
////        }
////        let data = Data([UInt8(value)])
////        BluetoothManager.shared.writeControlValue(data: data)
////    }
////
////    func findCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
////        // Implement a method to find the correct characteristic from BluetoothManager's connected peripheral.
////        // This should retrieve the characteristic from the discovered characteristics of the connected peripheral.
////        return BluetoothManager.shared.getCharacteristic(by: uuid)
////    }
////}
//
//
//class ControlViewController: UIViewController {
//    var stackView: UIStackView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupStackView()
//        addControls()
//    }
//
//    func setupStackView() {
//        stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .equalSpacing
//        stackView.alignment = .center
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
//        ])
//    }
//
//    func addControls() {
//        let deviceNames = ["Grow Light", "Heat Light", "Fan", "Water Pump", "Misting System"]
//        for (index, deviceName) in deviceNames.enumerated() {
//            let switchControl = UISwitch()
//            switchControl.tag = index
//            switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
//            
//            let label = UILabel()
//            label.text = deviceName
//            label.textAlignment = .right
//
//            let rowStack = UIStackView(arrangedSubviews: [label, switchControl])
//            rowStack.axis = .horizontal
//            rowStack.distribution = .equalSpacing
//
//            stackView.addArrangedSubview(rowStack)
//        }
//    }
//
//    @objc func switchChanged(_ sender: UISwitch) {
//        let commandValue: UInt8 = sender.isOn ? 0 : 1  // Modify based on actual control logic
//        let commandData = Data([commandValue])
//        BluetoothManager.shared.writeValue(data: commandData, forCharacteristicUUID: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
//    }
//}

import UIKit
import CoreBluetooth

class ControlViewController: UIViewController {
    var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        addControls()
    }

    func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

    func addControls() {
        let deviceNames = ["Grow Light", "Heat Light", "Fan", "Motor", "Misting System"]
        let commandValues = [0, 2, 4, 6, 8] // Starting command values for each device when turned on

        for (index, deviceName) in deviceNames.enumerated() {
            let switchControl = UISwitch()
            switchControl.tag = commandValues[index] // Tag each switch with its "turn on" command value
            switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            
            let label = UILabel()
            label.text = deviceName
            label.textAlignment = .right

            let rowStack = UIStackView(arrangedSubviews: [label, switchControl])
            rowStack.axis = .horizontal
            rowStack.distribution = .equalSpacing

            stackView.addArrangedSubview(rowStack)
        }
    }

    @objc func switchChanged(_ sender: UISwitch) {
        let baseValue = sender.tag
        let commandValue: UInt8 = sender.isOn ? UInt8(baseValue) : UInt8(baseValue + 1)
        print("Attempting to toggle \(sender.isOn ? "on" : "off") with command \(commandValue)")
        
        BluetoothManager.shared.writeValueToControlCharacteristic(value: commandValue)
    }
}
