//
//  RunnyNoseGraphView.swift
//  SymptomDiary
//
//  Created by Lukas Hirsch on 23.06.23.
//

import SwiftUI
import HealthKit

struct RunnyNoseGraphView: View {
    @ObservedObject var healthKitService = HealthKitService()
    
    var body: some View {
        VStack {
            Text("Runny Nose Graph")
                .font(.title)
                .padding()
            
            if healthKitService.runnyNoseData.isEmpty {
                Text("No data available")
                    .foregroundColor(.gray)
            } else {
                RunnyNoseGraph(severityValues: samplesToValues())
                    .frame(height: 200)
            }
        }
        .onAppear() {
            healthKitService.fetchRunnyNoseData()
        }
    }
    
    func samplesToValues() ->  [HKCategoryValueSeverity] {
        return healthKitService.runnyNoseData.map { HKCategoryValueSeverity(rawValue: $0.value )!}
        }
    
    
    }


struct RunnyNoseGraph: View {
    let severityValues: [HKCategoryValueSeverity]
    
    var body: some View {
        VStack {
            Text("Latest Runny Nose Values")
                .font(.headline)
            
            GeometryReader { geometry in
                HStack(spacing: 4) {
                    ForEach(severityValues, id: \.self) { severity in
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(colorForSeverity(severity))
                                .frame(height: barHeightForSeverity(severity, maxHeight: geometry.size.height))
                                .cornerRadius(4)
                            Text(severity.stringRepresentation)
                                .font(.caption)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    func colorForSeverity(_ severity: HKCategoryValueSeverity) -> Color {
        switch severity {
        case .unspecified:
            return .gray
        case .notPresent:
            return .green
        case .mild:
            return .yellow
        case .moderate:
            return .orange
        case .severe:
            return .red
        }
    }
    
    func barHeightForSeverity(_ severity: HKCategoryValueSeverity, maxHeight: CGFloat) -> CGFloat {
        let maxSeverity = HKCategoryValueSeverity.severe
        let percentage = CGFloat(severity.rawValue) / CGFloat(maxSeverity.rawValue)
        return maxHeight * percentage
    }
    
    
}

struct RunnyNoseGraphView_Previews: PreviewProvider {
    static var previews: some View {
        RunnyNoseGraphView(healthKitService: HealthKitService())
    }
}
