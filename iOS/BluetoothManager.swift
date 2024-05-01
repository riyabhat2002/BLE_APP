//
//  BluetoothManager.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.
//

//import CoreBluetooth
//
//protocol BluetoothManagerDelegate: AnyObject {
//    func didUpdateTemperature(_ temperature: Float)
//    func didUpdateHumidity(_ humidity: Int)
//    func didUpdateSoilMoisture(_ moisture: Float)
//    func didUpdateValue(for characteristic: CBCharacteristic, value: Data?)
//    func didWriteValue(for characteristic: CBCharacteristic)
//}
//
//class BluetoothManager: NSObject {
//    static let shared = BluetoothManager()
//    
//    var delegate: BluetoothManagerDelegate?
//    private var centralManager: CBCentralManager!
//    private var connectedPeripheral: CBPeripheral?
//    private var isReconnectEnabled = true
//    private var reconnectionAttempts = 0
//    private let maximumReconnectionAttempts = 50
//    private var reconnectionTimer: Timer?
//
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
//    }
//    
//    func startScanning() {
//        centralManager.scanForPeripherals(withServices: nil, options: nil)
//    }
//    
//    private func attemptReconnect() {
//        guard isReconnectEnabled, reconnectionAttempts < maximumReconnectionAttempts else {
//            print("Will not attempt further reconnections.")
//            return
//        }
//        
//        reconnectionAttempts += 1
//        print("Attempting to reconnect. Attempt #\(reconnectionAttempts)")
//        startScanning()
//    }
//    
//    private func resetReconnectionAttempts() {
//        reconnectionAttempts = 0
//        reconnectionTimer?.invalidate()
//        reconnectionTimer = nil
//    }
//}
//
//// MARK: - CBCentralManagerDelegate Methods
//extension BluetoothManager: CBCentralManagerDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            print("Bluetooth is powered on and available for use.")
//            startScanning()
//        } else {
//            print("Bluetooth is not available: \(central.state.rawValue)")
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if peripheral.name == "ECE453-Group07" {
//            connectedPeripheral = peripheral
//            centralManager.stopScan()
//            centralManager.connect(peripheral, options: nil)
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        resetReconnectionAttempts()
//        connectedPeripheral = peripheral
//        peripheral.delegate = self
//        peripheral.discoverServices(nil)
//    }
//    
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print("Failed to connect: \(error?.localizedDescription ?? "No error information")")
//        attemptReconnect()
//    }
//    
//    
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print("Disconnected from \(peripheral.name ?? "unknown device"): \(error?.localizedDescription ?? "No error information")")
//        
//        // If there's no error, it might be an intentional disconnect, so check a flag or error before reconnecting
//        
//            print("Will attempt to reconnect to \(peripheral.name ?? "unknown device") after disconnection.")
//            reconnectionTimer?.invalidate() // Invalidate any previous timer
//            reconnectionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
//                self?.centralManager.scanForPeripherals(withServices: nil, options: nil)
//            }
//        
//    }
//
//    private func shouldReconnectAfterDisconnection(_ error: Error?) -> Bool {
//        // Here you can decide based on the error whether to attempt a reconnect.
//        // If there's no error or if it's a certain type of error, return true.
//        // You can also check for a maximum number of reconnection attempts.
//        
//        // Example logic: Only reconnect if there is no error.
//        return error == nil && reconnectionAttempts < maximumReconnectionAttempts
//    }
//}
//
//// MARK: - CBPeripheralDelegate Methods
//// MARK: - CBPeripheralDelegate Methods
//extension BluetoothManager: CBPeripheralDelegate {
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else {
//            print("Error discovering services: \(error?.localizedDescription ?? "unknown error")")
//            return
//        }
//
//        for service in services {
//            print("Service found with UUID: \(service.uuid)")
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else {
//            print("Error discovering characteristics: \(error?.localizedDescription ?? "unknown error")")
//            return
//        }
//        
//        for characteristic in characteristics {
//            print("Characteristic found with UUID: \(characteristic.uuid)")
//
//            // Handle different characteristic properties
//            if characteristic.properties.contains(.read) {
//                peripheral.readValue(for: characteristic)
//            }
//
//            // Subscribe to notifications if the characteristic supports it
//            if characteristic.properties.contains(.notify) {
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//
//            // Add more cases here for other properties like .write, .writeWithoutResponse, etc.
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard let data = characteristic.value, error == nil else {
//            print("Error reading characteristics")
//            return
//        }
//        switch characteristic.uuid {
//            case CBUUID(string: "FC5031E4-1D63-4038-AEB7-6A3B20D7740C"):
//                if let temperature = data.toFloat() {
//                    delegate?.didUpdateTemperature(temperature)
//                }
//            case CBUUID(string: "2E75A5DD-A42B-420A-B9AB-3F15E19AE0EE"):
//                if let humidity = data.toInt() {
//                    delegate?.didUpdateHumidity(humidity)
//                }
//            case CBUUID(string: "2CA77EE6-AFFB-48FD-BA94-2E0745B36A3D"):
//                if let moisture = data.toFloat() {
//                    delegate?.didUpdateSoilMoisture(moisture)
//                }
//            default:
//                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
//    }
//
//
//        func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//            delegate?.didWriteValue(for: characteristic)
//        }
//
//        func writeValue(data: Data, for characteristic: CBCharacteristic) {
//            connectedPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
//        }
//
//
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("Error subscribing to notifications: \(error.localizedDescription)")
//            return
//        }
//        print("Subscription state updated for \(characteristic.uuid): isNotifying \(characteristic.isNotifying)")
//    }
//}
//
//extension Data {
//    func toFloat() -> Float? {
//        guard count >= MemoryLayout<Float>.size else {
//            print("Data size (\(count)) is too small to convert to Float")
//            return nil
//        }
//        return withUnsafeBytes { $0.load(as: Float.self) }
//    }
//
//    func toInt() -> Int? {
//        guard count >= MemoryLayout<Int>.size else {
//            print("Data size (\(count)) is too small to convert to Int")
//            return nil
//        }
//        return withUnsafeBytes { $0.load(as: Int.self) }
//    }
//}


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
    
    func findCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
        guard let services = connectedPeripheral?.services else { return nil }
        for service in services {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.uuid == uuid {
                        return characteristic
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

//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//        for characteristic in characteristics {
//            switch characteristic.uuid {
//                case .temperatureCharacteristicUUID:
//                    peripheral.readValue(for: characteristic) // if it's readable
//                    if characteristic.properties.contains(.notify) {
//                        peripheral.setNotifyValue(true, for: characteristic)
//                    }
//                case .humidityCharacteristicUUID, .moistureCharacteristicUUID:
//                    if characteristic.properties.contains(.notify) {
//                        peripheral.setNotifyValue(true, for: characteristic)
//                    }
//                case .controlCharacteristicUUID:
//                    if characteristic.properties.contains(.write) {
//                        // Store this characteristic if you need to write to it later
//                    }
//                default:
//                    print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//            }
//        }
//    }
    
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
            if characteristic.properties.contains(.write) {
                // This can be used to store reference for future writes
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

    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services, error == nil else {
//            print("Error discovering services: \(error?.localizedDescription ?? "unknown error")")
//            return
//        }
//
//        for service in services {
//            peripheral.discoverCharacteristics([CBUUID.temperatureCharacteristicUUID, CBUUID.humidityCharacteristicUUID, CBUUID.moistureCharacteristicUUID], for: service)
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics, error == nil else {
//            print("Error discovering characteristics: \(error?.localizedDescription ?? "unknown error")")
//            return
//        }
//        
//        for characteristic in characteristics {
//            print("Discovered Characteristic: \(characteristic.uuid)")
//            switch characteristic.uuid {
//            case CBUUID.temperatureCharacteristicUUID:
//                print("Temperature characteristic discovered.")
//            case CBUUID.humidityCharacteristicUUID:
//                print("Humidity characteristic discovered.")
//            case CBUUID.moistureCharacteristicUUID:
//                print("Soil Moisture characteristic discovered.")
//            default:
//                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//            }
//        }
//    }



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
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard let data = characteristic.value, error == nil else {
//            print("Error reading characteristics: \(error?.localizedDescription ?? "No error information")")
//            return
//        }
//
//        switch characteristic.uuid {
//        case CBUUID.temperatureCharacteristicUUID:
//            if let temperature = data.toTemperature() {
//                delegate?.didUpdateTemperature(temperature)
//            }
//        case CBUUID.humidityCharacteristicUUID:
//            if let humidity = data.toInt() { // Ensure you have a conversion method like toTemperature
//                delegate?.didUpdateHumidity(humidity)
//            }
//        case CBUUID.moistureCharacteristicUUID:
//            if let moisture = data.toFloatLittleEndian() { // Ensure you have a conversion method
//                delegate?.didUpdateSoilMoisture(moisture)
//            }
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
//    }


    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing to characteristic: \(error.localizedDescription)")
        } else {
            print("Successfully wrote value to \(characteristic.uuid)")
            delegate?.didWriteValue(for: characteristic)
        }
    }

        // Method to retrieve a characteristic
    func getCharacteristic(by uuid: CBUUID) -> CBCharacteristic? {
        for (_, characteristics) in characteristicsDictionary {
            if let characteristic = characteristics.first(where: { $0.uuid == uuid }) {
                return characteristic
            }
        }
        return nil
    }
    
    func writeValue(data: Data, for characteristic: CBCharacteristic, type: CBCharacteristicWriteType = .withResponse) {
        guard let peripheral = connectedPeripheral else {
            print("No connected peripheral to write to.")
            return
        }
        peripheral.writeValue(data, for: characteristic, type: type)
    }
    func writeControlValue(data: Data) {
        guard let controlChar = getCharacteristic(by: .controlCharacteristicUUID) else {
            print("Control characteristic not found")
            return
        }
        connectedPeripheral?.writeValue(data, for: controlChar, type: .withResponse)
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

