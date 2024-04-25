//
//  ControlViewController.swift
//  BLEAPP
//
//  Created by Patron on 4/24/24.


import UIKit

class ControlViewController: UIViewController {

    let temperatureSlider = createSlider()
    let humiditySlider = createSlider()
    let lightSlider = createSlider()

    let temperatureValueLabel = createValueLabel()
    let humidityValueLabel = createValueLabel()
    let lightValueLabel = createValueLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Control"
        setupControlSliders()
        view.backgroundColor = UIColor.systemBackground // Use system background for dark/light mode
    }

    private func setupControlSliders() {
        let temperatureControl = createControl(with: temperatureSlider, valueLabel: temperatureValueLabel, title: "Temperature")
        let humidityControl = createControl(with: humiditySlider, valueLabel: humidityValueLabel, title: "Humidity")
        let lightControl = createControl(with: lightSlider, valueLabel: lightValueLabel, title: "Light")

        let stackView = UIStackView(arrangedSubviews: [temperatureControl, humidityControl, lightControl])
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

    private func createControl(with slider: UISlider, valueLabel: UILabel, title: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18)

        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, slider, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 5

        return stackView
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        switch sender {
        case temperatureSlider:
            temperatureValueLabel.text = "\(value)°C"
        case humiditySlider:
            humidityValueLabel.text = "\(value)%"
        case lightSlider:
            lightValueLabel.text = "\(value)Lux"
        default:
            break
        }
    }
    
    static func createSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50 // Default value
        return slider
    }
    
    static func createValueLabel() -> UILabel {
        let label = UILabel()
        label.text = "50" // Default value
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }
}
