//  

import UIKit
import AppBaseFlow
import AppDesignSystem

final class BirthdayCell: UserDataCell {
    
    var didUpdateDate: ((Date) -> Void)?
    
    private(set) lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        return datePicker
    }()
    
    func configure(birthday: String) {
        contentView.clipsToBounds = true
        titleLabel.text = strings.profileBirthday
        subtitleTextField.text = birthday
        if let date = formatter.formatStringToDate(birthday) {
            datePicker.date = date
        }
    }
    
    override func setupHierarchy() {
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        super.setupHierarchy()
        contentView.addSubview(datePicker)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        datePicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(subtitleTextField.snp.bottom).inset(-8)
        }
    }
    
    func hideOrShowTimePicker() {
        if isDataEditing {
            datePicker.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(subtitleTextField.snp.bottom).inset(-8)
                make.bottom.equalToSuperview().inset(8)
            }
            subtitleTextField.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.top.equalTo(titleLabel.snp.bottom)
            }
        } else {
            datePicker.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(subtitleTextField.snp.bottom).inset(-8)
            }
            subtitleTextField.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.top.equalTo(titleLabel.snp.bottom)
                make.bottom.equalToSuperview().inset(8)

            }
        }
    }
    
    override func didTapEdit() {
        isDataEditing.toggle()
        hideOrShowTimePicker()
        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded()
        }
    }
    
    @objc private func dateChanged() {
        subtitleTextField.text = formatter.formatDateToString(datePicker.date)
        didUpdateDate?(datePicker.date)
    }
}


class CustomDatePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    private let pickerView = UIPickerView()
    
    // Дни, месяцы и годы
    private let days = (1...31).map { "\($0)" }
    private let months = Calendar.current.monthSymbols
    private let years = (1900...2024).map { "\($0)" } + ["—"] // Год может быть прочерком

    var selectedDate: (day: Int, month: Int, year: Int?)? {
        didSet {
            updateSelection()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
//        pickerView.setValue(UIColor.label, forKey: "textColor") // Цвет текста
//        pickerView.setValue(UIFont.systemFont(ofSize: 14), forKey: "font")
        
        
        addSubview(pickerView)
        pickerView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // День, месяц, год
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            if selectedDate?.month == 3 {
                return 4
            }
            return days.count
        case 1: return months.count
        case 2: return years.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title = ""
        switch component {
        case 0: title = days[row]
        case 1: title = months[row]
        case 2: title = years[row]
        default: return nil
        }
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let day = Int(days[pickerView.selectedRow(inComponent: 0)])!
        let month = pickerView.selectedRow(inComponent: 1) + 1
        let yearString = years[pickerView.selectedRow(inComponent: 2)]
        let year = yearString == "—" ? nil : Int(yearString)
        selectedDate = (day, month, year)
        pickerView.reloadComponent(0)
    }

    private func updateSelection() {
//        guard let date = selectedDate else { return }
//        
//        let dayIndex = days.firstIndex(of: "\(date.day)") ?? 0
//        let monthIndex = date.month - 1
//        let yearIndex = date.year == nil ? years.count - 1 : years.firstIndex(of: "\(date.year!)") ?? 0
//        
//        pickerView.selectRow(dayIndex, inComponent: 0, animated: true)
//        pickerView.selectRow(monthIndex, inComponent: 1, animated: true)
//        pickerView.selectRow(yearIndex, inComponent: 2, animated: true)
    }
}
