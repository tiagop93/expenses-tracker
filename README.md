# Expense Tracking Challenge

A lightweight iOS app to capture, store, and manage expense receipts offline. Built in Swift with SwiftUI, MVVM-C, and a Clean Architecture approach.

## 🚀 Getting Started

1. **Clone the repository**:

   ```bash
   git clone https://github.com/tiagop93/expenses-tracker.git
   cd expenses-tracker
   ```

2. **Open in Xcode**:

   ```bash
   open ExpenseTrackingChallenge.xcodeproj
   ```

3. **Build & Run**:

   * Select the `ExpenseTrackingChallenge` scheme
   * Press `⌘R` to run on simulator or device

4. **Run Tests**:

   * Press `⌘U` or go to **Product → Test**

## 📂 Project Structure

```
ExpenseTrackingChallenge/
├── App/                  # Entry point & Coordinator
├── Data/                 # Core Data stack & Repository
├── Domain/               # Domain models
├── Features/             # Feature modules (History, Form)
├── Preview Content/      # Mock helpers
├── Utilities/            # Extensions & helpers
└── Tests/                # Unit tests (XCTest targets)
```
