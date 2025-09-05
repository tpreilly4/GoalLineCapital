# Goal Line Capital iOS App

Goal Line Capital is a financial tools iOS application built with SwiftUI and SwiftData. The app provides various financial calculators and expense tracking functionality for Goal Line Capital's clients and prospects.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Critical Requirements

**PLATFORM REQUIREMENT**: This is an iOS application that requires macOS with Xcode to build and run. It CANNOT be built on Linux or Windows.

- Minimum iOS/iPadOS version: 17.6
- Swift version: 5.0
- Xcode project format (not Swift Package Manager)
- Uses SwiftUI framework and SwiftData for persistence

## Working Effectively

### Prerequisites
- Install Xcode from the Mac App Store (requires macOS)
- Ensure you have the latest iOS SDK installed
- For device testing: Apple Developer account and provisioning profiles

### Building and Running
- Open `GoalLineCapital.xcodeproj` in Xcode
- Select target device: iPhone/iPad Simulator or connected device
- Build and run: `Cmd+R` or Product > Run in Xcode
- Build only: `Cmd+B` or Product > Build in Xcode
- Clean build: `Cmd+Shift+K` or Product > Clean Build Folder

**NEVER CANCEL**: Build times typically 30-60 seconds for clean builds. Set timeout to 120+ seconds.

### Command Line Building (Alternative)
If working from command line on macOS:
```bash
# Build for simulator
xcodebuild -project GoalLineCapital.xcodeproj -scheme GoalLineCapital -destination 'platform=iOS Simulator,name=iPhone 15' build

# Archive for distribution (takes 2-5 minutes)
xcodebuild -project GoalLineCapital.xcodeproj -scheme GoalLineCapital archive -archivePath ./build/GoalLineCapital.xcarchive
```

**NEVER CANCEL**: Archive builds take 2-5 minutes. Set timeout to 10+ minutes.

## Project Structure

### Key Directories
```
GoalLineCapital/
├── GoalLineCapital.xcodeproj/          # Xcode project file
├── GoalLineCapital/                    # Main source directory
│   ├── GoalLineCapitalApp.swift        # App entry point (@main)
│   ├── Views/                          # All UI views
│   │   ├── Activities/                 # Main app screens
│   │   │   ├── HomeView.swift          # Landing page with navigation
│   │   │   ├── Tools/                  # Financial calculators
│   │   │   └── Trackers/               # Expense/savings tracking
│   │   ├── Components/                 # Reusable UI components
│   │   └── ViewModifiers/              # Custom view modifiers
│   ├── ExpenseTracker/                 # Expense tracking module
│   │   ├── Data/                       # SwiftData models
│   │   └── *.swift                     # Expense-related views
│   ├── Extensions/                     # Swift extensions
│   ├── Enums/                          # Type definitions
│   └── Assets.xcassets/                # Images, colors, app icons
```

### Important Files to Know
- `GoalLineCapitalApp.swift` - App entry point, SwiftData container setup
- `Views/Activities/HomeView.swift` - Main navigation screen
- `ExpenseTracker/Data/ExpenseItem.swift` - Core data model using SwiftData
- `Views/Components/DollarAmountTextField.swift` - Reusable currency input
- `Extensions/StringToDollarsDouble.swift` - Currency conversion utilities
- `Assets.xcassets/GoalLineBlue.colorset/` - Brand color definition

## Application Features

### Financial Tools
1. **Tip Calculator** (`Views/Activities/Tools/TipCalculatorView.swift`)
   - Bill amount input with tip percentage slider
   - Split bill functionality for multiple people
   
2. **Mortgage Payment Estimator** (`Views/Activities/Tools/MortgagePaymentCalculatorView.swift`)
   - Loan amount, interest rate, and term calculations
   - Monthly payment estimates
   
3. **Compound Interest Calculator** (`Views/Activities/Tools/CompoundInterestCalculatorView.swift`)
   - Investment growth projections
   - Compound interest calculations

### Tracking Features
1. **Expense Tracker** (`Views/Activities/Trackers/ExpenseTrackerView.swift`)
   - Add/edit/delete expenses with categories
   - Monthly grouping and totals
   - SwiftData persistence
   
2. **Savings Tracker** - Currently commented out in HomeView.swift

### Contact Features
- Calendly integration for scheduling meetings
- Direct phone and email links
- Apple Maps integration for office location

## Development Patterns

### SwiftData Usage
- `ExpenseItem` is the main @Model class
- Uses `@Query` for data fetching in views
- `modelContext` for CRUD operations
- Automatic persistence with no additional setup required

### UI Patterns
- Consistent use of `BrandingGradients().brandingGradient` for backgrounds
- `ListStartBrandingView()` and `ListEndBrandingView()` for consistent list styling
- Custom dollar input with `DollarAmountTextField`
- Navigation via `NavigationStack` and `NavigationLink`

### Brand Colors
- Primary brand color: `.goalLineBlue` (RGB: 43, 57, 144)
- Consistent gradient applications throughout the app

## Validation

### Manual Testing Scenarios
**ALWAYS test these scenarios after making changes:**

1. **Home Navigation Flow**:
   - Launch app and verify HomeView loads with Goal Line Capital logo
   - Tap each tool and tracker to ensure navigation works
   - Verify "Contact" section buttons open correct external apps

2. **Tip Calculator Flow**:
   - Enter bill amount using DollarAmountTextField
   - Adjust tip percentage slider
   - Toggle bill splitting and verify per-person calculations
   - Test edge cases: $0 bill, 0% tip, maximum people (20)

3. **Expense Tracker Flow**:
   - Add new expense with category and amount
   - Edit existing expense
   - Delete expense (swipe to delete)
   - Navigate to monthly detail view
   - Verify data persists after app restart

4. **Data Persistence**:
   - Add expenses, close app completely
   - Relaunch app and verify expenses are still present
   - Test across app backgrounding/foregrounding

### No Existing Tests
- No unit tests or UI tests currently exist
- If adding tests, create them in Xcode: File > New > Target > iOS Unit Testing Bundle
- Follow Apple's XCTest framework conventions for SwiftUI testing

## Common Development Tasks

### Adding New Features
1. Always follow existing UI patterns (BrandingGradients, consistent navigation)
2. For financial calculations, use `Double` type and `.currency(code: "USD")` formatting
3. Use `DollarAmountTextField` for currency inputs
4. Add new views to appropriate subdirectory in `Views/`

### Modifying Expense Tracker
- Data model changes require updating `ExpenseItem.swift`
- UI changes typically involve `ExpenseTrackerView.swift` and related views
- SwiftData handles migrations automatically for simple changes

### Styling Changes
- Brand colors defined in `Assets.xcassets/GoalLineBlue.colorset/`
- Gradients centralized in `Views/Components/Gradients.swift`
- Consistent spacing and styling via custom view modifiers

## Troubleshooting

### Build Issues
- Clean build folder if encountering cache issues: Product > Clean Build Folder
- Restart Xcode if Simulator stops responding
- Verify iOS Deployment Target matches your simulator version

### SwiftData Issues
- If data appears corrupted, delete app from simulator and reinstall
- SwiftData automatically handles simple schema migrations
- Check `@Query` syntax for data fetching issues

### Cannot Build on Non-Mac Platforms
- This project requires Xcode and iOS SDK which are only available on macOS
- Cross-platform development tools (e.g., React Native, Flutter) not used here
- For code review only: Files can be examined on any platform but not built/run

## Contact Information (App Context)
- Company: Goal Line Capital
- Address: 161 Madison Ave, Ste 230, Morristown, NJ 07960
- Email: info@GoalLineCapital.com  
- Phone: (908) 938-6361
- Meeting booking: calendly.com/bobby-goallinecapital/booking