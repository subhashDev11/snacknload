# Visual Design Specifications

## Enhanced UI Design System

### Color Palette

#### Primary Colors

- **Indigo**: `#6366F1` - Primary brand color
- **Purple**: `#8B5CF6` - Secondary accent
- **Cyan**: `#06B6D4` - Tertiary accent

#### Semantic Colors

- **Success**: `#10B981` (Emerald Green)
  - Darker: `#059669`
  - Lighter: `#34D399`
- **Error**: `#EF4444` (Red)
  - Darker: `#DC2626`
  - Lighter: `#F87171`
- **Warning**: `#F59E0B` (Amber)
  - Darker: `#D97706`
  - Lighter: `#FBBF24`
- **Info**: `#3B82F6` (Blue)
  - Darker: `#2563EB`
  - Lighter: `#60A5FA`

### Typography

#### Font Weights

- **Bold**: 700 (Titles)
- **Semi-bold**: 600 (Body text, buttons)
- **Medium**: 500 (Secondary text)
- **Regular**: 400 (Descriptions)

#### Font Sizes

- **Title**: 24px
- **Subtitle**: 18px
- **Body**: 15-16px
- **Caption**: 13-14px
- **Small**: 12px

### Spacing System

#### Padding

- **XS**: 4px
- **S**: 8px
- **M**: 12px
- **L**: 16px
- **XL**: 20px
- **XXL**: 24px

#### Margins

- **Component**: 16px
- **Section**: 24px
- **Container**: 50px

### Border Radius

#### Sizes

- **Small**: 8px (Icon containers)
- **Medium**: 12px (Buttons)
- **Large**: 16px (Cards, Snackbars)
- **XLarge**: 20px (Containers)

### Shadows

#### Elevation Levels

**Level 1** (Subtle)

```dart
BoxShadow(
  color: Colors.black.withValues(alpha: 0.05),
  blurRadius: 10,
  offset: Offset(0, 4),
)
```

**Level 2** (Medium)

```dart
BoxShadow(
  color: Colors.black.withValues(alpha: 0.1),
  blurRadius: 20,
  spreadRadius: 5,
  offset: Offset(0, 8),
)
```

**Level 3** (Strong)

```dart
BoxShadow(
  color: bgColor.withValues(alpha: 0.3),
  blurRadius: 20,
  offset: Offset(0, 8),
)
```

### Glassmorphism Effect

#### Standard Glass

```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          bgColor.withValues(alpha: 0.9),
          bgColor.withValues(alpha: 0.8),
        ],
      ),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: 1.5,
      ),
    ),
  ),
)
```

#### Light Glass (Loading)

```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          backgroundColor.withValues(alpha: 0.8),
          backgroundColor.withValues(alpha: 0.6),
        ],
      ),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.2),
      ),
    ),
  ),
)
```

### Animation Specifications

#### Timing

- **Fast**: 200ms (Fade, opacity changes)
- **Normal**: 300ms (Scale, transforms)
- **Slow**: 400ms (Slide, complex animations)

#### Curves

- **easeOut**: Fade animations
- **easeOutCubic**: Slide animations
- **easeOutBack**: Scale animations (bounce effect)

#### Animation Sequences

**Loading Entry**

1. Scale: 0 → 1 (300ms, easeOutBack)
2. Fade: 0 → 1 (300ms, easeOut)
3. Blur: 0 → 5 (300ms, linear)

**Snackbar Entry**

1. Slide: -1/1 → 0 (400ms, easeOutCubic)
2. Fade: 0 → 1 (400ms, easeOut)

**Progress Bar**

- Linear countdown from 1 → 0
- Duration matches snackbar duration
- Smooth, continuous animation

### Component Specifications

#### Enhanced Loading Container

- **Size**: Auto (based on content)
- **Min Padding**: 50px margin
- **Border Radius**: 16px
- **Blur**: 10px sigma
- **Shadow**: Level 2
- **Gradient**: 0.8 → 0.6 alpha

#### Enhanced Snackbar

- **Max Width**: 500px
- **Margin**: 16px all sides
- **Padding**: 16px horizontal, 14px vertical
- **Border Radius**: 16px
- **Blur**: 10px sigma
- **Shadow**: Level 3 (colored)
- **Progress Height**: 3px

#### Icon Container

- **Size**: 24px icon
- **Padding**: 8px
- **Background**: White 20% opacity
- **Border Radius**: 8px

#### Close Button

- **Size**: 20px icon
- **Padding**: Zero
- **Color**: White
- **Tap Area**: 44x44px (minimum)

### Interaction States

#### Hover (Implicit)

- Slight scale increase (1.02)
- Shadow intensification

#### Pressed

- Scale decrease (0.98)
- Shadow reduction

#### Dragging (Swipe)

- Follow finger position
- Fade on distance > 100px
- Spring back if < 100px

### Accessibility

#### Contrast Ratios

- White text on colored backgrounds: 4.5:1 minimum
- Icon visibility: High contrast required

#### Touch Targets

- Minimum: 44x44px
- Recommended: 48x48px

#### Animation

- Respect `prefers-reduced-motion`
- Provide instant mode option

### Responsive Design

#### Breakpoints

- **Mobile**: < 600px
- **Tablet**: 600-1024px
- **Desktop**: > 1024px

#### Snackbar Width

- Mobile: Full width - 32px margin
- Tablet/Desktop: Max 500px

### Performance Guidelines

#### Blur Usage

- Use sparingly on low-end devices
- Provide `useBlur: false` option
- Limit blur area size

#### Animation Performance

- Use `AnimatedBuilder` for efficiency
- Avoid rebuilding entire tree
- Cache complex calculations

#### Memory Management

- Dispose controllers properly
- Cancel timers on dismiss
- Clear callbacks on unmount

## Implementation Checklist

- [x] Color system implemented
- [x] Typography defined
- [x] Spacing system applied
- [x] Border radius standardized
- [x] Shadow levels created
- [x] Glassmorphism effect added
- [x] Animations implemented
- [x] Component specs followed
- [x] Interaction states handled
- [x] Accessibility considered
- [x] Responsive design applied
- [x] Performance optimized
