# Cat Breed App - UI Design Specification

## Thumbnail Card Design (List/Grid View)

### Essential Data for Thumbnail Display:
```dart
Card Layout:
┌─────────────────────────────────────┐
│  [Breed Image]           [❤️ Fav]   │
│                                     │
│  Breed Name              Cross Icon │
│  Origin Country          ⭐⭐⭐⭐⭐    │
│                                     │
│  Size: Large    Coat: Long          │
│  Temperament: Gentle, Playful       │
│  Lifespan: 12-15 years              │
│                                     │
│  [View Details Button]              │
└─────────────────────────────────────┘
```

### Thumbnail Data Fields:
- **Primary Image** (from images array - first image)
- **Breed Name** 
- **Cross Breed Indicator** (if is_crossbreed = true)
- **Origin Country**
- **Size** (from appearance.size)
- **Coat Length** (from appearance.coat_length)
- **Top 2 Temperament Traits** (from temperament.traits)
- **Lifespan Range** (from health.lifespan or life_span_years)
- **Recognition Stars** (based on recognition array length)
- **Favorite Button**

---

## Detailed Breed Page - Tabbed Interface

### Tab Structure:

#### **Tab 1: Overview** 📋
- **Hero Image Carousel** (all images from images array)
- **Basic Information Card:**
  - Breed Name & Aliases
  - Origin & Breed Group
  - Recognition Status (with organization badges)
  - Cross Breed Banner (if applicable)
- **Quick Stats Row:**
  - Size | Weight | Lifespan | Activity Level
- **History Section** (breed history text)
- **Fun Facts** (fun_facts array as expandable cards)

#### **Tab 2: Appearance** 🎨
- **Physical Characteristics:**
  - Body Type
  - Weight Range (with male/female breakdown)
  - Average Height
  - Size Category
- **Coat Information:**
  - Coat Length & Description
  - Available Colors (color chips/swatches)
  - Distinctive Features (with icons)
- **Features Gallery:**
  - Eye Colors (with color samples)
  - Distinct Features (illustrated)
- **Appearance Images** (filtered from images array)

#### **Tab 3: Temperament & Behavior** 🐱
- **Personality Overview** (temperament summary)
- **Trait Radar Chart:**
  - Activity Level
  - Vocalization Level  
  - Affection Level
  - Intelligence
  - Trainability
- **Social Compatibility:**
  - Good with Kids (✓/✗ with icons)
  - Good with Dogs
  - Good with Other Cats
- **Behavioral Traits** (temperament.traits as tags)
- **Other Notable Traits** (other_traits section)

#### **Tab 4: Care & Maintenance** 🧴
- **Grooming Requirements:**
  - Grooming Needs
  - Detailed Grooming Instructions
  - Shedding Level
- **Exercise & Activity:**
  - Exercise Needs
  - Activity Recommendations
  - Play Requirements
- **Nutrition:**
  - Dietary Notes
  - Nutrition Guidelines
  - Feeding Recommendations

#### **Tab 5: Health & Veterinary** 🏥
- **Health Overview:**
  - Lifespan Range
  - Common Health Issues (with severity indicators)
  - Genetic Tests Available
- **Veterinary Care Schedule:**
  - Vaccination Schedule
  - Deworming Schedule
  - Dental Care
  - Special Screenings
- **Common Medications:**
  - Preventative Treatments (expandable cards)
  - Usage Instructions
  - Purpose & Benefits
- **Parasite Prevention** (detailed recommendations)

#### **Tab 6: Breeding Information** 🧬
**Note: Only show if is_crossbreed = true OR breeding data exists**

- **Cross Breed Information** (if applicable):
  - Parent Breeds (with clickable links)
  - Parent Breed Images
  - Generation & Development History
  - Inheritance Patterns
- **Breeding Compatibility:**
  - Compatible Breeds
  - Genetic Precautions
- **Reproductive Data:**
  - Typical Litter Size
  - Gestation Period
  - Maturity Age
- **Hybrid Vigor Information** (if cross breed)

#### **Tab 7: Resources & Links** 🔗
- **Official Recognition:**
  - Breed Standard Links (clickable)
  - Organization Badges
- **Adoption Resources:**
  - Rescue Organizations
  - Breeder Directories
  - Adoption Websites
- **Related Breeds** (clickable breed cards)
- **Videos** (embedded or linked)
- **External Resources**

---

## Special Features & UI Elements

### Cross Breed Indicators:
- **Thumbnail:** Special "Cross Breed" badge with dual-color design
- **Detail Page:** Prominent cross breed banner on Overview tab
- **Parent Breed Cards:** In Breeding tab with navigation links

### Interactive Elements:
- **Image Galleries:** Swipeable carousels with captions
- **Expandable Cards:** For detailed information sections
- **Progress Bars:** For trait levels (activity, vocalization, etc.)
- **Color Swatches:** For coat colors and eye colors
- **Clickable Badges:** For recognitions and traits
- **Navigation Links:** Between related breeds and parent breeds

### Accessibility Features:
- **High Contrast Mode** support
- **Font Size** adjustments
- **Screen Reader** friendly labels
- **Keyboard Navigation** support

### Data Completeness Indicators:
- **Progress Ring:** Show how much breed information is available
- **Missing Data Placeholders:** Graceful handling of null/empty fields
- **Last Updated:** Display last_updated timestamp

---

## Technical Implementation Notes

### Data Mapping:
```dart
// Thumbnail Data Extraction
class BreedThumbnail {
  String primaryImage = breed.images[0].url;
  String name = breed.name;
  bool isCrossBreed = breed.is_crossbreed;
  String origin = breed.origin;
  String size = breed.appearance.size;
  String coatLength = breed.appearance.coat_length;
  List<String> topTraits = breed.temperament.traits.take(2);
  String lifespan = breed.health.lifespan;
  int recognitionCount = breed.recognition.length;
}
```

### Tab Navigation:
- **Bottom Tab Bar** with icons for main sections
- **Floating Action Button** for favorites
- **App Bar** with breed name and share functionality
- **Back Navigation** to breed list

### Performance Considerations:
- **Lazy Loading** for tab content
- **Image Caching** for breed photos
- **Search Functionality** across all breed data
- **Filtering Options** by size, origin, temperament, etc.

This design ensures every piece of data from your JSON structure is displayed in an organized, user-friendly manner while maintaining excellent navigation and visual appeal! 