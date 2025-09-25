# Appointment Booking App - UI Design System

## Design Philosophy
Clean, modern, and intuitive design following Material Design 3 principles with emphasis on usability and accessibility.

## Color Palette

### Primary Colors
- **Primary**: #6750A4 (Purple 500)
- **Primary Container**: #EADDFF (Purple 100)
- **On Primary**: #FFFFFF
- **On Primary Container**: #21005D

### Secondary Colors
- **Secondary**: #625B71 (Neutral Variant 500)
- **Secondary Container**: #E8DEF8 (Neutral Variant 100)
- **On Secondary**: #FFFFFF
- **On Secondary Container**: #1D192B

### Surface Colors
- **Surface**: #FFFBFE
- **Surface Variant**: #E7E0EC
- **On Surface**: #1C1B1F
- **On Surface Variant**: #49454F

### Status Colors
- **Success**: #4CAF50 (Green 500)
- **Warning**: #FF9800 (Orange 500)
- **Error**: #F44336 (Red 500)
- **Info**: #2196F3 (Blue 500)

## Typography

### Font Family
- Primary: Roboto (Android) / SF Pro (iOS)
- Fallback: System default

### Text Styles
- **Display Large**: 57sp, Regular
- **Display Medium**: 45sp, Regular
- **Display Small**: 36sp, Regular
- **Headline Large**: 32sp, Regular
- **Headline Medium**: 28sp, Regular
- **Headline Small**: 24sp, Regular
- **Title Large**: 22sp, Regular
- **Title Medium**: 16sp, Medium
- **Title Small**: 14sp, Medium
- **Body Large**: 16sp, Regular
- **Body Medium**: 14sp, Regular
- **Body Small**: 12sp, Regular
- **Label Large**: 14sp, Medium
- **Label Medium**: 12sp, Medium
- **Label Small**: 11sp, Medium

## Spacing System
- **xs**: 4dp
- **sm**: 8dp
- **md**: 16dp
- **lg**: 24dp
- **xl**: 32dp
- **xxl**: 48dp

## Component Specifications

### App Bar
- Height: 64dp
- Background: Primary color
- Title: Title Large, On Primary color
- Actions: 48dp touch target
- Elevation: 4dp

### Bottom Navigation
- Height: 80dp
- Background: Surface color
- Selected: Primary color
- Unselected: On Surface Variant
- Icons: 24dp
- Labels: Label Medium

### Cards (Appointment Items)
- Corner Radius: 12dp
- Elevation: 2dp
- Padding: 16dp
- Background: Surface color
- Border: 1dp, Surface Variant (when needed)

### Buttons
- **Primary Button**: 
  - Height: 40dp
  - Corner Radius: 20dp
  - Background: Primary color
  - Text: Label Large, On Primary color
- **Secondary Button**:
  - Height: 40dp
  - Corner Radius: 20dp
  - Border: 1dp, Primary color
  - Text: Label Large, Primary color

### Form Fields
- Height: 56dp
- Corner Radius: 4dp
- Border: 1dp, On Surface Variant
- Focused Border: 2dp, Primary color
- Padding: 16dp horizontal, 16dp vertical
- Label: Body Small, On Surface Variant

## Screen Layouts

### Home Screen (List View)
```
┌─────────────────────────────────────┐
│ ← Appointments              + Add   │ App Bar
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ Meeting with Client             │ │ Appointment
│ │ Today, 2:00 PM - 3:00 PM       │ │ Card
│ │ Conference Room A               │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Doctor Appointment              │ │
│ │ Tomorrow, 10:00 AM - 11:00 AM   │ │
│ │ Medical Center                  │ │
│ └─────────────────────────────────┘ │
│                                     │
├─────────────────────────────────────┤
│ [List] [Calendar]                   │ Bottom Nav
└─────────────────────────────────────┘
```

### Calendar View
```
┌─────────────────────────────────────┐
│ ← Calendar                  + Add   │ App Bar
├─────────────────────────────────────┤
│     September 2025                  │ Month Header
│ S  M  T  W  T  F  S                │
│ 1  2  3  4  5  6  7                │ Calendar
│ 8  9 10 11 12 13 14                │ Grid
│15 16 17 18 19 20 21                │
│22 23 24 25 26 27 28                │
│29 30                               │
│                                     │
│ Selected: September 25, 2025        │ Selected Date
│ ┌─────────────────────────────────┐ │ Info
│ │ Meeting with Client             │ │
│ │ 2:00 PM - 3:00 PM              │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ [List] [Calendar]                   │ Bottom Nav
└─────────────────────────────────────┘
```

### Add/Edit Appointment Form
```
┌─────────────────────────────────────┐
│ ← New Appointment          Save     │ App Bar
├─────────────────────────────────────┤
│ Title *                             │
│ ┌─────────────────────────────────┐ │ Text Field
│ │ Enter appointment title         │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Date *                              │
│ ┌─────────────────────────────────┐ │ Date Picker
│ │ September 25, 2025         📅   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Time *                              │
│ ┌─────────────────────────────────┐ │ Time Picker
│ │ 2:00 PM                    🕐   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Location                            │
│ ┌─────────────────────────────────┐ │ Text Field
│ │ Enter location                  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Description                         │
│ ┌─────────────────────────────────┐ │ Multi-line
│ │ Enter description               │ │ Text Field
│ │                                 │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## Interaction Patterns

### Navigation
- Bottom navigation for primary views (List/Calendar)
- Floating Action Button for quick appointment creation
- Swipe gestures for calendar navigation
- Pull-to-refresh on list view

### Feedback
- Snackbars for success/error messages
- Loading indicators for async operations
- Haptic feedback for important actions
- Visual state changes for interactive elements

### Accessibility
- Minimum touch target: 48dp
- Color contrast ratio: 4.5:1 minimum
- Screen reader support
- Keyboard navigation support
- Focus indicators

## Animation Guidelines
- Duration: 200-300ms for micro-interactions
- Easing: Standard curve (cubic-bezier(0.4, 0.0, 0.2, 1))
- Page transitions: Slide animations
- Loading states: Circular progress indicators
- Success actions: Scale and fade animations