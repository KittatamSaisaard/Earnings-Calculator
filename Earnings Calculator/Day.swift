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
    
    var payRate: Double = 27.24
    var payAmount: Double = 0
    var totalHours: Double = 0
    var weekDay: Bool = true
    var monToFriSixPMToElevenPMPayRate: Double = 32.69
    var ordinarySpecialHoursAmount: Double = 0
    var ordinarySpecialPayAmount: Double = 0
    var specialSpecialHoursAmount: Double = 0
    var specialSpecialPayAmount: Double = 0
    
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
    @IBOutlet weak var normalPayAndHours: UIView!
    @IBOutlet weak var specialPayAndHours: UIView!
    @IBOutlet weak var totalSpecialPay: UILabel!
    @IBOutlet weak var totalSpecialHours: UILabel!
    @IBOutlet weak var ordinarySpecialPay: UILabel!
    @IBOutlet weak var ordinarySpecialHours: UILabel!
    @IBOutlet weak var specialSpecialPay: UILabel!
    @IBOutlet weak var specialSpecialHours: UILabel!
    
    var timeObject: [String: Any] = [
        "outsideSixAndEleven": 0,
        "betweenSixAndEleven": 0,
        "totalTime": 0
    ]

    func calculateTime(inTime: UIDatePicker, outTime: UIDatePicker) -> Void {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let inTimeFormatted = formatter.date(from: formatter.string(from: inTime.date))
        let outTimeFormatted = formatter.date(from: formatter.string(from: outTime.date))
        let sixPM = formatter.date(from: "18:00")
        let elevenPM = formatter.date(from: "23:00")
        
        //Calcuate the total shift time as a decimal in terms of hours
        var timeDiff = Double(outTime.date.timeIntervalSince(inTime.date))/3600
        var outsideSixAndEleven: Double = 0
        var betweenSixAndEleven: Double = 0
        
        //Start and finish before 6pm OR Start and finish after 11pm
        if((inTimeFormatted! <= sixPM! && outTimeFormatted! <= sixPM!) || (inTimeFormatted! >= elevenPM! && outTimeFormatted! >= elevenPM!)) {
            outsideSixAndEleven = Double(outTimeFormatted!.timeIntervalSince(inTimeFormatted!))/3600
            betweenSixAndEleven = 0
        } else
        //Start and finish between 6pm and 11pm
        if(inTimeFormatted! > sixPM! && outTimeFormatted! < elevenPM!) {
            outsideSixAndEleven = 0
            betweenSixAndEleven = Double(outTimeFormatted!.timeIntervalSince(inTimeFormatted!))/3600
        } else
        //Start before 6pm and finish before 11pm
        if(inTimeFormatted! <= sixPM! && outTimeFormatted! < elevenPM!) {
            outsideSixAndEleven = Double(sixPM!.timeIntervalSince(inTimeFormatted!))/3600
            betweenSixAndEleven = Double(outTimeFormatted!.timeIntervalSince(sixPM!))/3600
        } else
        //Start before 6pm and finish after 11pm
        if(inTimeFormatted! <= sixPM! && outTimeFormatted! >= elevenPM!) {
            outsideSixAndEleven = Double(sixPM!.timeIntervalSince(inTimeFormatted!))/3600 + Double(outTime.date.timeIntervalSince(elevenPM!))/3600
            betweenSixAndEleven = Double(elevenPM!.timeIntervalSince(sixPM!))/3600
        }

        //If worked over 5 hours, then subtract 30 minutes from the total shift time
        if (timeDiff > 5.0) {
            timeDiff = timeDiff - 0.5
            if(betweenSixAndEleven >= 0.5){
                betweenSixAndEleven = betweenSixAndEleven - 0.5
            } else if (betweenSixAndEleven > 0) {
                outsideSixAndEleven = outsideSixAndEleven - 0.5 + betweenSixAndEleven
                betweenSixAndEleven = betweenSixAndEleven - betweenSixAndEleven
            } else {
                outsideSixAndEleven = outsideSixAndEleven - 0.5
            }
        }

        timeObject["outsideSixAndEleven"] = outsideSixAndEleven
        timeObject["betweenSixAndEleven"] = betweenSixAndEleven
        timeObject["totalTime"] = timeDiff
    }
    
    var dayOffToggle = false

    func updateResults() {
        calculateTime(inTime: inTime, outTime: outTime)
        if (dayOffToggle == true) {
            payAmount = 0
            totalHours = 0
        } else if (weekDay == true) {
//            if ((timeObject["betweenSixAndEleven"] as! Double) > 0) {
//                normalPayAndHours.isHidden = true
//                specialPayAndHours.isHidden = false
//            } else {
//                normalPayAndHours.isHidden = false
//                specialPayAndHours.isHidden = true
//            }
            totalHours = timeObject["totalTime"] as! Double
            payAmount = (payRate * (timeObject["outsideSixAndEleven"] as! Double).rounded(toPlaces: 2)) + (monToFriSixPMToElevenPMPayRate * (timeObject["betweenSixAndEleven"] as! Double).rounded(toPlaces: 2))
            
            ordinarySpecialHoursAmount = timeObject["outsideSixAndEleven"] as! Double
            ordinarySpecialPayAmount = payRate * ordinarySpecialHoursAmount.rounded(toPlaces: 2)
            
            specialSpecialHoursAmount = timeObject["betweenSixAndEleven"] as! Double
            specialSpecialPayAmount = monToFriSixPMToElevenPMPayRate * specialSpecialHoursAmount.rounded(toPlaces: 2)
        } else {
            totalHours = timeObject["totalTime"] as! Double
            payAmount = payRate * totalHours.rounded(toPlaces: 2)
        }
        
        if (((timeObject["betweenSixAndEleven"] as! Double) > 0) && (weekDay == true)) {
            normalPayAndHours.isHidden = true
            specialPayAndHours.isHidden = false
            
            ordinarySpecialHours.text = String(format: "%.2f", ordinarySpecialHoursAmount.rounded(toPlaces: 3)) + " hours"
            ordinarySpecialPay.text = "$" + String(format: "%.2f", ordinarySpecialPayAmount.rounded(toPlaces: 3))
            
            specialSpecialHours.text = String(format: "%.2f", specialSpecialHoursAmount.rounded(toPlaces: 3)) + " hours"
            specialSpecialPay.text = "$" + String(format: "%.2f", specialSpecialPayAmount.rounded(toPlaces: 3))
            
            totalSpecialHours.text = String(format: "%.2f", totalHours.rounded(toPlaces: 3)) + " hours"
            totalSpecialPay.text = "$" + String(format: "%.2f", payAmount.rounded(toPlaces: 3))
        } else {
            normalPayAndHours.isHidden = false
            specialPayAndHours.isHidden = true
            Hours.text = String(format: "%.2f", totalHours.rounded(toPlaces: 3)) + " hours"
            Pay.text = "$" + String(format: "%.2f", payAmount.rounded(toPlaces: 3))
        }
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
