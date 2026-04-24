/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI

struct AdLogsView: View {
    let logs: [String]
    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) { isExpanded.toggle() }
            } label: {
                HStack {
                    Text("Logs")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.blue)
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("logs_toggle")

            if isExpanded {
                ScrollViewReader { proxy in
                    ScrollView {
                        Text(logs.joined(separator: "\n"))
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .id("end")
                            .accessibilityIdentifier(CommonAccessibility.logsTextView)
                    }
                    .frame(height: 60)
                    .onChange(of: logs.count) { _ in
                        withAnimation { proxy.scrollTo("end") }
                    }
                }
            }

            Divider()
        }
    }
}
