//
//  BluetoothManager.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.
//

import CoreBluetooth

extension CBUUID {
    static let controlCharacteristicUUID = CBUUID(string: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F")
    static let temperatureCharacteristicUUID = CBUUID(string: "FC5031E4-1D63-4038-AEB7-6A3B20D7740C")
    static let humidityCharacteristicUUID = CBUUID(string: "2E75A5DD-A42B-420A-B9AB-3F15E19AE0EE")
    static let moistureCharacteristicUUID = CBUUID(string: "2CA77EE6-AFFB-48FD-BA94-2E0745B36A3D")
}

protocol BluetoothManagerDelegate: AnyObject {
    func didUpdateTemperature(_ temperature: Float)
    func didUpdateHumidity(_ humidity: Int)
    func didUpdateSoilMoisture(_ moisture: Float)
    func didUpdateValue(for characteristic: CBCharacteristic, value: Data?)
    func didWriteValue(for characteristic: CBCharacteristic)
}

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    static let shared = BluetoothManager()
    
    var delegate: BluetoothManagerDelegate?
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var isReconnectEnabled = true
    private var reconnectionAttempts = 0
    private let maximumReconnectionAttempts = 50
    private var reconnectionTimer: Timer?
    var updateTimer: Timer?
    
    private var characteristicsDictionary = [CBUUID: [CBCharacteristic]]()
    private let myServiceUUID = CBUUID(string: "B65E8494-7C3B-4C41-B0A6-E7E08A776AF5") // Change this to your actual service UUID

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startRegularRead() {
        updateTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(readCharacteristics), userInfo: nil, repeats: true)
    }
    
    @objc func readCharacteristics() {
        guard let peripheral = connectedPeripheral else { return }
        // List of characteristic UUIDs you need to read
        let characteristicUUIDs = [
            CBUUID.temperatureCharacteristicUUID,
            CBUUID.humidityCharacteristicUUID,
            CBUUID.moistureCharacteristicUUID
        ]
        
        for uuid in characteristicUUIDs {
            if let characteristic = findCharacteristic(by: uuid) {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
//    func findCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
//        guard let services = connectedPeripheral?.services else { return nil }
//        for service in services {
//            if let characteristics = service.characteristics {
//                for characteristic in characteristics {
//                    if characteristic.uuid == uuid {
//                        return characteristic
//                    }
//                }
//            }
//        }
//        return nil
//    }
    
//    private func findCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
//        guard let services = connectedPeripheral?.services else { return nil }
//        for service in services {
//            if let characteristics = service.characteristics {
//                for characteristic in characteristics where characteristic.uuid == uuid {
//                    return characteristic
//                }
//            }
//        }
//        return nil
//    }
    
    func findCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
        if let services = connectedPeripheral?.services {
            for service in services {
                if let characteristics = service.characteristics {
                    for characteristic in characteristics {
                        if characteristic.uuid == uuid {
                            return characteristic
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func stopTimer() {
        updateTimer?.invalidate()
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
    
    func stopScanning() {
        centralManager.stopScan()
    }

    func connectPeripheral(_ peripheral: CBPeripheral) {
        centralManager.stopScan()
        connectedPeripheral = peripheral
        connectedPeripheral!.delegate = self
        centralManager.connect(connectedPeripheral!, options: nil)
    }
    

    func disconnectPeripheral() {
        guard let peripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }

    // Implement CBCentralManagerDelegate, CBPeripheralDelegate methods to handle connection, discovery, reading and writing.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is powered on and available for use.")
            startScanning()
        } else {
            print("Bluetooth is not available: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "ECE453-Group07" {
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
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics, error == nil else {
            print("Error discovering characteristics: \(error?.localizedDescription ?? "unknown error")")
            return
        }

        for characteristic in characteristics {
            print("Discovered Characteristic: \(characteristic.uuid)")
            // Read any readable characteristic initially
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            // Subscribe to notifications if available
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            // Handle writable characteristics as needed
//            if characteristic.properties.contains(.write) {
//                // This can be used to store reference for future writes
//            }
            if characteristic.uuid == CBUUID(string: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F") {
                if characteristic.properties.contains(.write) {
                    // Log that we have found our writable characteristic
                    print("Control characteristic is writable.")
                }
            }
        }
    }

    func startRegularReads() {
        guard let peripheral = connectedPeripheral else { return }
        let readInterval = TimeInterval(5) // every 5 seconds
        Timer.scheduledTimer(withTimeInterval: readInterval, repeats: true) { [weak self] _ in
            guard let characteristics = self?.getReadableCharacteristics() else { return }
            for characteristic in characteristics {
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func getReadableCharacteristics() -> [CBCharacteristic]? {
        guard let services = connectedPeripheral?.services else { return nil }
        var readableCharacteristics = [CBCharacteristic]()
        for service in services {
            if let characteristics = service.characteristics {
                for characteristic in characteristics where characteristic.properties.contains(.read) {
                    readableCharacteristics.append(characteristic)
                }
            }
        }
        return readableCharacteristics
    }


    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, error == nil else {
            print("Error updating value for \(characteristic.uuid): \(error?.localizedDescription ?? "unknown")")
            return
        }
        print("Received data: \(data.map { String(format: "%02x", $0) }.joined())")
        
        switch characteristic.uuid {
        case CBUUID.temperatureCharacteristicUUID:
            if let temperature = data.toTemperature() {
                print("Converted temperature: \(temperature) °C")
                delegate?.didUpdateTemperature(temperature)
            } else {
                print("Could not convert data to Float for temperature")
            }
        case CBUUID.humidityCharacteristicUUID:
            if let humidity = data.toUInt32AsInt() {
                delegate?.didUpdateHumidity(humidity)
            } else {
                print("Could not convert data to Int for humidity")
            }
        case CBUUID.moistureCharacteristicUUID:
            if let moisture = data.toFloatLittleEndian() {
                delegate?.didUpdateSoilMoisture(moisture)
            } else {
                print("Could not convert data to Float for moisture")
            }
        case CBUUID.controlCharacteristicUUID:
                print("Data received for control characteristic")
                // Handle specific logic for control characteristic if needed
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }


//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("Error writing to characteristic: \(error.localizedDescription)")
//        } else {
//            print("Successfully wrote value to \(characteristic.uuid)")
//            delegate?.didWriteValue(for: characteristic)
//        }
//    }
//
//        // Method to retrieve a characteristic
//    func getCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
//        for (_, characteristics) in characteristicsDictionary {
//            if let characteristic = characteristics.first(where: { $0.uuid == uuid }) {
//                return characteristic
//            }
//        }
//        return nil
//    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Failed to write value for \(characteristic.uuid): \(error.localizedDescription)")
        } else {
            print("Successfully wrote value to \(characteristic.uuid)")
        }
    }

    
    func writeValue(data: Data, forCharacteristicUUID uuidString: String) {
        guard let peripheral = connectedPeripheral,
              let characteristic = findCharacteristic(by: CBUUID(string: uuidString)) else {
            print("Characteristic or peripheral not found.")
            return
        }

        if characteristic.properties.contains(.write) {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        } else {
            print("Characteristic is not writable.")
        }
    }
    
    
    func writeControlValue(value: UInt8) {
        guard let peripheral = connectedPeripheral,
              let characteristics = peripheral.services?.flatMap({ $0.characteristics }).flatMap({ $0 }),
              let controlCharacteristic = characteristics.first(where: { $0.uuid == CBUUID(string: "6277B4A0-BFE6-4ED5-A7A8-88A40B07514F") }) else {
            print("Control characteristic not found.")
            return
        }

        let data = Data([value])
        peripheral.writeValue(data, for: controlCharacteristic, type: .withResponse)
    }
    
    func writeValueToControlCharacteristic(value: UInt8) {
        guard let peripheral = connectedPeripheral else {
            print("No connected peripheral.")
            return
        }
        
        guard let controlCharacteristic = findCharacteristic(by: .controlCharacteristicUUID) else {
            print("Control characteristic not found.")
            return
        }
        
        if controlCharacteristic.properties.contains(.writeWithoutResponse) {
            let data = Data([value])
            print("Writing value: \(value) to characteristic: \(controlCharacteristic.uuid.uuidString)")
            peripheral.writeValue(data, for: controlCharacteristic, type: .withoutResponse)
        } else {
            print("Characteristic does not support write without response.")
        }
    }
}

extension Data {
    func toFloatLittleEndian() -> Float? {
        guard self.count >= 4 else {
            print("Data size (\(self.count)) is too small to convert to Float")
            return nil
        }
        let value = self.withUnsafeBytes {
            $0.load(as: UInt32.self)
        }
        return Float(bitPattern: UInt32(littleEndian: value))
    }
    
    func toTemperature() -> Float? {
        guard self.count >= 4 else {
            print("Data size (\(self.count)) is too small to interpret as a signed 32-bit integer")
            return nil
        }
        let value = self.withUnsafeBytes {
            $0.load(as: Int32.self)
        }
        // Divide by 100.0 to convert the integer temperature into degrees Celsius.
        return Float(value) / 100.0
    }
    
    func toUInt32AsInt() -> Int? {
        guard self.count >= MemoryLayout<UInt32>.size else {
            print("Data size (\(self.count)) is too small to convert to UInt32")
            return nil
        }
        let value = self.withUnsafeBytes {
            $0.load(as: UInt32.self).littleEndian // Assuming data is little-endian
        }
        return Int(value) // Convert UInt32 to Int
    }
}

