# GoalLineCapital iOS App - Copilot Instructions

## Project Overview
GoalLineCapital is a SwiftUI-based iOS financial tools app that provides various calculators and utilities for personal finance management, including mortgage calculators, compound interest calculators, and expense tracking features.

## Architecture & Structure
- **Platform**: iOS app built with SwiftUI
- **Language**: Swift
- **Minimum iOS**: Check Info.plist for current target
- **Project Structure**:
  - `Views/`: SwiftUI views organized by feature (Activities, Components, Tools)
  - `Extensions/`: Swift extensions for utility functions
  - `Enums/`: App-specific enumerations
  - `ExpenseTracker/`: Expense tracking functionality

## Key Components
- **DollarAmountTextField**: Custom text field for currency input with automatic formatting
- **Financial Calculators**: Mortgage, compound interest, tip calculators
- **Expense Tracking**: Personal finance management features

## Development Guidelines

### Code Style
- Follow Swift conventions and SwiftUI best practices
- Use meaningful variable and function names
- Maintain consistent indentation and spacing
- Add comments for complex business logic

### UI/UX Requirements
- Ensure accessibility compliance with VoiceOver support
- Maintain consistent visual design across the app
- Prioritize user experience for financial data input
- Test on multiple iOS device sizes

### Financial Data Handling
- Always use appropriate number formatting for currency display
- Validate financial inputs to prevent errors
- Handle edge cases for zero values and large numbers
- Ensure precision in financial calculations

### Testing Notes
- **Manual Testing**: The project maintainer (@tpreilly4) handles all manual testing
- Focus on unit tests for business logic and utility functions
- Test financial calculations for accuracy
- Verify currency formatting across different locales

### Common Patterns
- Use `@Binding` for two-way data flow in reusable components
- Implement `@FocusState` for keyboard management
- Use NumberFormatter for consistent currency display
- Apply ViewModifiers for reusable input validation

### Performance Considerations
- Optimize view updates for financial calculations
- Use appropriate data types for financial precision
- Consider memory usage when handling large datasets

## Current Focus Areas
- Improving user experience for large number input
- Enhancing currency formatting and validation
- Maintaining backward compatibility with existing features