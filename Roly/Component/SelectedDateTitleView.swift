//
//  SelectedDateTitleView.swift
//  Roly
//
//  Created by 劉采璇 on 3/3/25.

import SwiftUI

struct SelectedDateTitleView: View {
    @Binding var dueDate: Date
    @State private var isDatePickerShown = false
    
    let isDisabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            
            Button(action: {
                isDatePickerShown.toggle()
            }) {
//                HStack(alignment: .center) {
//                    VStack(alignment: .leading, spacing: 0) {
//                        Text(String(dueDate.year))
//                            .font(.caption2)
//                        Text(monthAbbreviation(for: dueDate))
//                            .font(.system(size: 20, weight: .bold))
//                    }
//                    Text(String(format: "%02d", dueDate.day))
//                        .font(.system(size: 40, weight: .bold))
//                    
//                    // Chevron button to trigger date picker
//                    Image(systemName: "chevron.down")
//                        .fontWeight(.bold)
////                        .foregroundColor(.gray)
////                        .font(.system(size: 14))
//                }
                HStack(spacing: 0) {
                    Text(monthAbbreviation(for: dueDate))
                        .fontWeight(.bold)
                        .padding(.trailing, 10)
                    Text(String(format: "%02d", dueDate.day))
                    Text(",")
                        .padding(.trailing, 10)
                    Text(String(dueDate.year))
                }
                .foregroundColor(.rolyMainPink)
                .frame(width: 160, height: 40)
                .background(RoundedRectangle(cornerRadius: 10).fill(.rolyMainPink.opacity(0.2)))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isDisabled)
        }
        .sheet(isPresented: $isDatePickerShown) {
            DatePickerSheetView(dueDate: $dueDate, isShown: $isDatePickerShown, isDisabled: isDisabled)
        }
    }
    
    // Get month abbreviation (e.g., "MAR")
    private func monthAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM" // Get month abbreviation
        return formatter.string(from: date).uppercased()
    }
}

struct DatePickerSheetView: View {
    @Binding var dueDate: Date
    @Binding var isShown: Bool
    @State private var temporaryDate: Date
    
    let isDisabled: Bool
    
    init(dueDate: Binding<Date>, isShown: Binding<Bool>, isDisabled: Bool) {
        self._dueDate = dueDate
        self._isShown = isShown
        self._temporaryDate = State(initialValue: dueDate.wrappedValue)
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 0) {
                    Text(monthAbbreviation(for: dueDate))
                        .padding(.trailing, 10)
                    Text(String(format: "%02d", dueDate.day))
                    Text(",")
                        .padding(.trailing, 10)
                    Text(String(dueDate.year))
                }
                .padding(5)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.rolyMainPink.opacity(0.5)))
                Spacer()
                Button("Done") {
                    dueDate = temporaryDate
                    isShown = false
                }
                .font(.headline)
                .disabled(isDisabled)
            }
            .padding(.horizontal, 30)
            
            DatePicker(
                "Select Date",
                selection: $temporaryDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .disabled(isDisabled)
        }
        .presentationDetents([.height(300)])
    }
    private func monthAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM" // Get month abbreviation
        return formatter.string(from: date).uppercased()
    }
}

struct SelectedDateTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedDateTitleView(dueDate: .constant(Date.now), isDisabled: false)
            .previewLayout(.fixed(width: 150, height: 30))
    }
}
