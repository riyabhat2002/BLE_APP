//
//  BluetoothManager.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.
//

import CoreBluetooth

class BluetoothManager: NSObject {
    static let shared = BluetoothManager()
    
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var isReconnectEnabled = true
    private var reconnectionAttempts = 0
    private let maximumReconnectionAttempts = 3
    private var reconnectionTimer: Timer?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    private func attemptReconnect() {
        guard isReconnectEnabled, reconnectionAttempts < maximumReconnectionAttempts else {
            print("Will not attempt further reconnections.")
            return
        }
        
        reconnectionAttempts += 1
        print("Attempting to reconnect. Attempt #\(reconnectionAttempts)")
        startScanning()
    }
    
    private func resetReconnectionAttempts() {
        reconnectionAttempts = 0
        reconnectionTimer?.invalidate()
        reconnectionTimer = nil
    }
}

// MARK: - CBCentralManagerDelegate Methods
extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is powered on and available for use.")
            startScanning()
        } else {
            print("Bluetooth is not available: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "ECE453-07" {
            connectedPeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        resetReconnectionAttempts()
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect: \(error?.localizedDescription ?? "No error information")")
        attemptReconnect()
    }
    
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("Disconnected from \(peripheral.name ?? "unknown device"): \(error?.localizedDescription ?? "No error information")")
//        
//        if let error = error as? CBError, error.code == .peripheralDisconnected {
//            attemptReconnect()
//        } else {
//            resetReconnectionAttempts()
//        }
//    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "unknown device"): \(error?.localizedDescription ?? "No error information")")
        
        // If there's no error, it might be an intentional disconnect, so check a flag or error before reconnecting
        if shouldReconnectAfterDisconnection(error) {
            print("Will attempt to reconnect to \(peripheral.name ?? "unknown device") after disconnection.")
            reconnectionTimer?.invalidate() // Invalidate any previous timer
            reconnectionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                self?.centralManager.scanForPeripherals(withServices: nil, options: nil)
            }
        } else {
            // Handle the case where we do not want to reconnect
            print("Disconnection was intentional or due to an error, will not reconnect.")
        }
    }

    private func shouldReconnectAfterDisconnection(_ error: Error?) -> Bool {
        // Here you can decide based on the error whether to attempt a reconnect.
        // If there's no error or if it's a certain type of error, return true.
        // You can also check for a maximum number of reconnection attempts.
        
        // Example logic: Only reconnect if there is no error.
        return error == nil && reconnectionAttempts < maximumReconnectionAttempts
    }
}

// MARK: - CBPeripheralDelegate Methods
extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            print("Error discovering services: \(error?.localizedDescription ?? "unknown error")")
            return
        }

        for service in services {
            print("Service found with UUID: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            print("Error discovering characteristics: \(error?.localizedDescription ?? "unknown error")")
            return
        }
        
        for characteristic in characteristics {
            print("Characteristic found with UUID: \(characteristic.uuid)")
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
            print("Error reading characteristics: \(error?.localizedDescription ?? "No error information")")
            return
        }
        let valueString = String(data: data, encoding: .utf8) ?? "N/A"
        print("Value for \(characteristic.uuid) is \(valueString)")
    }
}
