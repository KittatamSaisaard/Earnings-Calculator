//
//  Day.swift
//  Earnings Calculator
//
//  Created by Kittatam Saisaard on 21/1/21.
//

import UIKit

class Day: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var payRate: Double = 26.76
    var payAmount: Double = 0
    var totalHours: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        updateResults()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        updateResults()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("Day", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var dayOff: UILabel!
    
    @IBOutlet weak var inTime: UIDatePicker!
    @IBOutlet weak var outTime: UIDatePicker!

    @IBOutlet weak var Hours: UILabel!
    @IBOutlet weak var Pay: UILabel!
    @IBOutlet weak var Details: UIView!

    func calculateTime(inTime: UIDatePicker, outTime: UIDatePicker) -> Double {

        //Calcuate the total shift time as a decimal in terms of hours
        var timeDiff = Double(outTime.date.timeIntervalSince(inTime.date))/3600

        //If worked over 5 hours, then subtract 30 minutes from the total shift time
        if (timeDiff > 5.0) {
            timeDiff = timeDiff - 0.5
        }

        return timeDiff
    }
    
    var dayOffToggle = false

    func updateResults() {
        if (dayOffToggle == true) {
            payAmount = 0
            totalHours = 0
        } else {
            totalHours = calculateTime(inTime: inTime, outTime: outTime)
            payAmount = (payRate * totalHours.rounded(toPlaces: 2))
        }
        Hours.text = String(format: "%.2f", totalHours.rounded(toPlaces: 3)) + " hours"
        Pay.text = "$" + String(format: "%.2f", payAmount.rounded(toPlaces: 3))
    }

    @IBAction func In(_ sender: UIDatePicker) {
        updateResults()
    }

    @IBAction func Out(_ sender: UIDatePicker) {
        updateResults()
    }

    @IBOutlet weak var toggleSwitch: UISwitch!
    
    @IBAction func toggleDay(_ sender: UISwitch) {
        if (sender.isOn) {
            dayOffToggle = false
            updateResults()
            Details.isHidden = false
            dayOff.isHidden = true
        } else {
            dayOffToggle = true
            updateResults()
            Details.isHidden = true
            dayOff.isHidden = false
        }
    }
    
    func toggleDayForced(toggle: Bool) {
        if (toggle == true) {
            dayOffToggle = false
            updateResults()
            Details.isHidden = false
            dayOff.isHidden = true
        } else {
            dayOffToggle = true
            updateResults()
            Details.isHidden = true
            dayOff.isHidden = false
        }
    }
}
