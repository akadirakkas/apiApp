//
//  CalculatorTableViewController.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 22.03.2021.
//

import UIKit
import Combine
class CalculatorTableViewController : UITableViewController{
    
    
    @IBOutlet weak var currentValueLabel : UILabel!
    @IBOutlet weak var investmentAmountLabel : UILabel!
    @IBOutlet weak var gainLabel : UILabel!
    @IBOutlet weak var yieldLabel : UILabel!
    @IBOutlet weak var annualReturnLabel : UILabel!
    @IBOutlet weak var initialInvestmentAmountTextField : UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField : UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField : UITextField!
    @IBOutlet weak var symbolLabel : UILabel!
    @IBOutlet weak var nameNameLabel : UILabel!
    @IBOutlet weak var dateSlider : UISlider!
    
    
    
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel : UILabel!
    @Published private var initialDateOfInvestmentIndex : Int?
    @Published private var initialInvestmentAmount : Int?
    @Published private var monthlyDollarCostAveragingAmount : Int?
    private var subscribers = Set<AnyCancellable>()
    private let dcaService = DCAService()
    
    var asset : Asset?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFeilds()
        observeForm()
        setupDateSlider()
        resetViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInvestmentAmountTextField.becomeFirstResponder()
    }
    
    
    private func  setupViews() {
        navigationItem.title = asset?.searchResult.symbol
        symbolLabel.text = asset?.searchResult.symbol
        nameNameLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addbrackets()
           
        }
    }
    
    private func setupTextFeilds() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    
    private func observeForm() {
        $initialDateOfInvestmentIndex.sink { [weak self](index) in
            guard let index  = index else{ return}
            self?.dateSlider.value = index.floatValaue
            if let dateString = self?.asset?.timeSeriesMonthlyAdjusted.getMonthInfos()[index].date.MMYYFormat{
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            self?.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDollarCostAveragingTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            self?.monthlyDollarCostAveragingAmount = Int(text) ?? 0
        }.store(in: &subscribers)
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveragingAmount, $initialDateOfInvestmentIndex).sink { [weak self] (initialInvestmentAmount, monthlyDollarCostAveragingAmount, initialDateOfInvestmentIndex) in
            
            guard let initialInvestmentAmount = initialInvestmentAmount,
                  let monthlyDollarCostAveragingAmount = monthlyDollarCostAveragingAmount,
                  let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex , let asset = self?.asset else { return }
            
          
            
            let result = self?.dcaService.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount.doubleValue,
                initialDateOfInvestmentIndex: initialDateOfInvestmentIndex,
                monthlyDollarCostAveragingAmount:monthlyDollarCostAveragingAmount.doubleValue )
            
            let isProfitable = (result?.isProfitable == true)
            
            let gainSymbol = isProfitable ? "+"  :  ""
            
            
            self?.currentValueLabel.backgroundColor = isProfitable ? .themeGreenShame : .themeRedShame
            self?.currentValueLabel.text = result?.currentValue.currencyFormat
            self?.investmentAmountLabel.text = result?.invesmentAmount.toCurrencyFormat(hasDecimalPlaces: false)
            self?.gainLabel.text = result?.gain.toCurrencyFormat(hasDollarSymbol: false, hasDecimalPlaces: false).prefix(withText : gainSymbol)
            self?.yieldLabel.text = result?.yeild.percentageFormat.prefix(withText: gainSymbol).addbrackets()
            self?.annualReturnLabel.text = result?.annualReturn.percentageFormat.prefix(withText: gainSymbol).addbrackets()
            
        }.store(in: &subscribers)
        
    }
    
    private func  setupDateSlider(){
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfos().count {
            let dateSliderCount =  count - 1
            dateSlider.maximumValue = dateSliderCount.floatValaue
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showDateSelection" ,
            let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController ,
           let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
            dateSelectionTableViewController.didSelectDate = { [weak self] index in
                self?.handleDidSelectDate(at: index)
                
            }
        }
    }
    
    private func handleDidSelectDate(at index : Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else {return}
        navigationController?.popViewController(animated: true)
        if let montInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos() {
            initialDateOfInvestmentIndex = index
            let montInfo = montInfos[index]
            let dateString = montInfo.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
    
    
    private func resetViews() {
        currentValueLabel.text = "0.00"
        investmentAmountLabel.text = "0.00"
        gainLabel.text = "-"
        yieldLabel.text = "-"
        annualReturnLabel.text = "-"
        
    }
    
    @IBAction func dateSliderChange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
    }
    
    
}


extension CalculatorTableViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestmentTextField{
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        return true
    }
}
