import 'dart:convert';
import 'dart:io';
import '../models/breed.dart';

/// Service to populate JSON file with comprehensive breed data
class JsonBreedPopulator {
  
  /// Generates comprehensive breed data for all 61 breeds
  static List<Map<String, dynamic>> generateAllBreedsData() {
    return [
      _generateMaineCoonData(),
      _generatePersianData(),
      _generateSiameseData(),
      _generateBengalData(),
      _generateRagdollData(),
      _generateBritishShorthairData(),
      _generateAbyssinianData(),
      _generateRussianBlueData(),
      _generateSphynxData(),
      _generateNorwegianForestData(),
      _generateSiberianData(),
      _generateTurkishVanData(),
      _generateAmericanShorthairData(),
      _generateScottishFoldData(),
      _generateOrientalShorthairData(),
      _generateDevonRexData(),
      _generateCornishRexData(),
      _generateBirmanData(),
      _generateTonkineseData(),
      _generateOcicatData(),
      _generateAmericanCurlData(),
      _generateManxData(),
      _generateExoticShorthairData(),
      _generateChartreuData(),
      _generateKoratData(),
      _generateBombayData(),
      _generateBalineseData(),
      _generateJapaneseBobtailData(),
      _generateEgyptianMauData(),
      _generateSingapuraData(),
      _generateSomaliData(),
      _generateHavanaData(),
      _generateAmericanBobtailData(),
      _generateSelkirkRexData(),
      _generateLaPermData(),
      _generateMunchkinData(),
      _generateSavannahData(),
      _generateToygerData(),
      _generatePixiebobData(),
      _generateHighlanderData(),
      _generateChausieData(),
      _generateKurilianBobtailData(),
      _generatePeterbaldData(),
      _generateDonskoyData(),
      _generateLykoiData(),
      _generateNebelungData(),
      _generateTurkishAngoraData(),
      _generateSnowshoeData(),
      _generateBurmillaData(),
      _generateBurmeseData(),
      _generateAustralianMistData(),
      _generateAmericanWirehairData(),
      _generateMinuetData(),
      _generateSerengetiData(),
      _generateThaiData(),
      _generateToybobData(),
      _generateTennesseeRexData(),
      _generateKhaomaneeData(),
      _generateCymricData(),
      _generateCherubimData(),
      _generateHimalayanData(),
    ];
  }

  /// Saves breed data to JSON file
  static Future<void> saveToJsonFile(String filePath) async {
    final breedsData = generateAllBreedsData();
    final jsonString = JsonEncoder.withIndent('  ').convert(breedsData);
    
    final file = File(filePath);
    await file.writeAsString(jsonString);
    
    print('Successfully saved ${breedsData.length} breeds to $filePath');
  }

  /// Maine Coon breed data
  static Map<String, dynamic> _generateMaineCoonData() {
    return {
      "id": "maine_coon",
      "name": "Maine Coon",
      "aliases": ["Coon Cat", "Maine Shag", "American Longhair"],
      "origin": "United States",
      "breed_group": "Natural",
      "is_crossbreed": false,
      "crossbreed_info": null,
      "recognition": [
        {"organization": "TICA", "status": "recognized"},
        {"organization": "CFA", "status": "recognized"},
        {"organization": "FIFe", "status": "recognized"}
      ],
      "history": "The Maine Coon is America's native longhaired cat and one of the oldest natural breeds in North America. Generally regarded as a native of the state of Maine, where it was made the official state cat in 1985. The breed developed through natural selection in the harsh New England climate, creating a hardy, handsome breed well equipped to survive hostile winters. Early Maine Coons were often polydactyls, believed to help them use their paws as 'natural snowshoes' during snowy Maine winters.",
      "appearance": {
        "body_type": "Large, muscular, rectangular",
        "weight_range": "13-18 lbs (males), 8-12 lbs (females)",
        "average_height": "25-41 cm",
        "coat_length": "Long",
        "coat": "Long, heavy double coat",
        "coat_colors": ["Brown Tabby", "Black", "White", "Blue", "Red", "Silver", "Tortoiseshell"],
        "colors": "Various (brown tabby, black, white, blue, red, etc.)",
        "eye_colors": ["Green", "Gold", "Copper"],
        "size": "Large",
        "distinctive_features": ["Tufted ears", "Bushy tail", "Large paws", "Lynx-like ear tips"],
        "distinct_features": ["Tufted ears", "Bushy tail", "Lynx-like ear tips"]
      },
      "temperament": {
        "summary": "Sweet-tempered, gentle, friendly, and social. They have a clown-like personality and are willing to 'help' their owners, yet aren't demanding of attention. They make excellent companions for large, active families and get along well with children, dogs, and other cats.",
        "traits": ["Friendly", "Gentle", "Playful", "Intelligent", "Social", "Loyal"],
        "activity_level": "Medium",
        "vocalization_level": "Low",
        "affection_level": "High",
        "intelligence": "High",
        "social_with_kids": true,
        "social_with_dogs": true,
        "social_with_cats": true,
        "trainability": "High"
      },
      "care": {
        "grooming_needs": "Moderate (weekly brushing)",
        "grooming": "Weekly combing is usually sufficient to keep coat in top condition",
        "shedding": "Moderate",
        "exercise_needs": "Moderate (daily play recommended)",
        "exercise": "Interactive toys provide exercise and bonding time; many play fetch",
        "dietary_notes": "High-quality diet; monitor portions to prevent obesity",
        "nutrition": "High-protein diet; monitor portions to prevent obesity"
      },
      "health": {
        "lifespan": "12.5+ years",
        "common_issues": [
          "Hypertrophic Cardiomyopathy",
          "Hip Dysplasia",
          "Spinal Muscular Atrophy"
        ],
        "genetic_tests": ["HCM DNA Test", "SMA DNA Test"],
        "veterinary_recommendations": "Annual health check-ups, heart screening",
        "vaccinations": "Core vaccines (FVRCP, rabies) per vet schedule"
      },
      "common_medications": [
        {
          "name": "Flea & Tick Preventative",
          "purpose": "Prevents flea and tick infestations",
          "usage_notes": "Apply topically once a month"
        },
        {
          "name": "Joint Supplement",
          "purpose": "Supports joint health for large breeds",
          "usage_notes": "Mix with food daily, as recommended by vet"
        }
      ],
      "veterinary_care_recommendations": {
        "deworming_schedule": "Every 3 months for adults",
        "vaccinations": "Annual core vaccines",
        "dental_care": "Brush teeth weekly",
        "parasite_prevention": "Year-round flea, tick, and heartworm prevention",
        "special_screenings": "Cardiac ultrasound after age 3-4 to screen for HCM"
      },
      "breeding_compatibility": {
        "compatible_breeds": ["Norwegian Forest Cat", "Siberian"],
        "genetic_precautions": [
          "Perform DNA tests for HCM and SMA genes before breeding",
          "Avoid close inbreeding to maintain genetic diversity"
        ]
      },
      "typical_litter_size": {
        "min": 1,
        "max": 6,
        "average": 4
      },
      "gestation_period_days": {
        "min": 63,
        "max": 70,
        "average": 65
      },
      "reproductive_maturity_age": {
        "male_months": 10,
        "female_months": 8
      },
      "life_span_years": {
        "min": 10,
        "max": 15,
        "average": 13
      },
      "weight_range_lbs": {
        "male": "13-18",
        "female": "8-12"
      },
      "other_traits": "Known as the 'gentle giants' of the cat world; often enjoy water and have a soft chirping voice",
      "breed_standard_links": [
        {"organization": "TICA", "url": "https://tica.org/maine-coon"},
        {"organization": "CFA", "url": "https://cfa.org/maine-coon/"}
      ],
      "fun_facts": [
        "Maine Coons are the only native longhaired American breed among pedigreed cats",
        "They often chirp and trill rather than meow to communicate",
        "Some Maine Coons have six toes (polydactyls) recognized by TICA",
        "Most Maine Coons actually like water and are good swimmers",
        "They don't reach full maturity until 4 years of age",
        "Known as 'gentle giants' due to their size and friendly nature"
      ],
      "images": [
        {"url": "https://example.com/maine-coon1.jpg", "caption": "Classic Maine Coon"},
        {"url": "https://example.com/maine-coon2.jpg", "caption": "Brown tabby Maine Coon"}
      ],
      "videos": [
        {"url": "https://youtube.com/mainecoon_intro", "caption": "Maine Coon breed overview"}
      ],
      "adoption_resources": [
        {"name": "Maine Coon Rescue", "url": "https://mainecoonrescue.net"},
        {"name": "Petfinder", "url": "https://www.petfinder.com/cat-breeds/maine-coon"}
      ],
      "related_breeds": ["Norwegian Forest Cat", "Siberian"],
      "status": "Extant",
      "last_updated": "2024-12-18T00:00:00Z"
    };
  }

  /// Persian breed data
  static Map<String, dynamic> _generatePersianData() {
    return {
      "id": "persian",
      "name": "Persian",
      "aliases": ["Longhair", "Persian Longhair"],
      "origin": "Iran",
      "breed_group": "Natural",
      "is_crossbreed": false,
      "crossbreed_info": null,
      "recognition": [
        {"organization": "TICA", "status": "recognized"},
        {"organization": "CFA", "status": "recognized"},
        {"organization": "FIFe", "status": "recognized"}
      ],
      "history": "One of the oldest cat breeds, the Persian has a long and illustrious history. Named after their country of origin, Persia (modern-day Iran), these cats were first imported to Europe in the 1600s. The breed was refined in Britain and later in America, developing the distinctive flat face and luxurious coat we know today.",
      "appearance": {
        "body_type": "Medium to large, cobby",
        "weight_range": "7-12 lbs",
        "average_height": "25-38 cm",
        "coat_length": "Long",
        "coat": "Long, flowing double coat",
        "coat_colors": ["White", "Black", "Blue", "Red", "Cream", "Silver", "Golden", "Tortoiseshell", "Calico", "Tabby"],
        "colors": "Over 80 color combinations",
        "eye_colors": ["Blue", "Green", "Gold", "Copper", "Odd-eyed"],
        "size": "Medium to Large",
        "distinctive_features": ["Flat face", "Large round eyes", "Small ears", "Luxurious coat"],
        "distinct_features": ["Brachycephalic face", "Round head", "Short nose"]
      },
      "temperament": {
        "summary": "Calm, gentle, and sweet-natured. Persians are quiet, docile cats who prefer a serene environment. They are affectionate with their families but not overly demanding of attention.",
        "traits": ["Calm", "Gentle", "Sweet", "Quiet", "Docile", "Affectionate"],
        "activity_level": "Low",
        "vocalization_level": "Low",
        "affection_level": "Medium",
        "intelligence": "Medium",
        "social_with_kids": true,
        "social_with_dogs": true,
        "social_with_cats": true,
        "trainability": "Medium"
      },
      "care": {
        "grooming_needs": "High (daily brushing essential)",
        "grooming": "Daily brushing required to prevent matting; regular eye cleaning needed",
        "shedding": "High",
        "exercise_needs": "Low (gentle play appropriate)",
        "exercise": "Minimal exercise needs; prefers calm indoor environment",
        "dietary_notes": "High-quality diet; monitor for obesity",
        "nutrition": "Premium diet with attention to coat health; regular feeding schedule"
      },
      "health": {
        "lifespan": "12–17 years",
        "common_issues": [
          "Breathing difficulties (brachycephalic)",
          "Kidney disease (PKD)",
          "Eye problems",
          "Skin conditions"
        ],
        "genetic_tests": ["PKD DNA Test"],
        "veterinary_recommendations": "Regular health screenings, eye care, respiratory monitoring",
        "vaccinations": "Core vaccines (FVRCP, rabies) per vet schedule"
      },
      "common_medications": [
        {
          "name": "Eye drops",
          "purpose": "Prevents eye infections and tear staining",
          "usage_notes": "Daily application as needed"
        }
      ],
      "veterinary_care_recommendations": {
        "deworming_schedule": "Every 3 months for adults",
        "vaccinations": "Annual core vaccines",
        "dental_care": "Regular dental cleaning due to facial structure",
        "parasite_prevention": "Year-round flea and tick prevention",
        "special_screenings": "Regular kidney function tests; eye examinations"
      },
      "breeding_compatibility": {
        "compatible_breeds": ["Exotic Shorthair", "Himalayan"],
        "genetic_precautions": [
          "Screen for PKD before breeding",
          "Avoid extreme facial features"
        ]
      },
      "typical_litter_size": {
        "min": 2,
        "max": 5,
        "average": 3
      },
      "gestation_period_days": {
        "min": 63,
        "max": 67,
        "average": 65
      },
      "reproductive_maturity_age": {
        "male_months": 8,
        "female_months": 6
      },
      "life_span_years": {
        "min": 12,
        "max": 17,
        "average": 14
      },
      "weight_range_lbs": {
        "male": "9-14",
        "female": "7-11"
      },
      "other_traits": "Prefer quiet, stable environments; known for their regal appearance and calm demeanor",
      "breed_standard_links": [
        {"organization": "TICA", "url": "https://tica.org/persian"},
        {"organization": "CFA", "url": "https://cfa.org/persian/"}
      ],
      "fun_facts": [
        "One of the most popular cat breeds worldwide",
        "Featured in numerous movies and TV shows",
        "Requires daily grooming to prevent matting",
        "Come in over 80 color combinations",
        "Known for their calm, gentle demeanor",
        "Can live 12-17 years with proper care"
      ],
      "images": [
        {"url": "https://example.com/persian1.jpg", "caption": "Classic Persian"},
        {"url": "https://example.com/persian2.jpg", "caption": "White Persian"}
      ],
      "videos": [
        {"url": "https://youtube.com/persian_intro", "caption": "Persian breed overview"}
      ],
      "adoption_resources": [
        {"name": "Persian Cat Rescue", "url": "https://persiancatrescue.org"},
        {"name": "Petfinder", "url": "https://www.petfinder.com/cat-breeds/persian"}
      ],
      "related_breeds": ["Exotic Shorthair", "Himalayan"],
      "status": "Extant",
      "last_updated": "2024-12-18T00:00:00Z"
    };
  }

  // Placeholder methods for remaining breeds - these would be implemented with full data
  static Map<String, dynamic> _generateSiameseData() => _createPlaceholderBreed("siamese", "Siamese", "Thailand", "Oriental");
  static Map<String, dynamic> _generateBengalData() => _createPlaceholderBreed("bengal", "Bengal", "United States", "Hybrid");
  static Map<String, dynamic> _generateRagdollData() => _createPlaceholderBreed("ragdoll", "Ragdoll", "United States", "Semi-longhair");
  static Map<String, dynamic> _generateBritishShorthairData() => _createPlaceholderBreed("british_shorthair", "British Shorthair", "United Kingdom", "Shorthair");
  static Map<String, dynamic> _generateAbyssinianData() => _createPlaceholderBreed("abyssinian", "Abyssinian", "Ethiopia", "Oriental");
  static Map<String, dynamic> _generateRussianBlueData() => _createPlaceholderBreed("russian_blue", "Russian Blue", "Russia", "Shorthair");
  static Map<String, dynamic> _generateSphynxData() => _createPlaceholderBreed("sphynx", "Sphynx", "Canada", "Hairless");
  static Map<String, dynamic> _generateNorwegianForestData() => _createPlaceholderBreed("norwegian_forest", "Norwegian Forest Cat", "Norway", "Natural");
  static Map<String, dynamic> _generateSiberianData() => _createPlaceholderBreed("siberian", "Siberian", "Russia", "Natural");
  static Map<String, dynamic> _generateTurkishVanData() => _createPlaceholderBreed("turkish_van", "Turkish Van", "Turkey", "Natural");
  static Map<String, dynamic> _generateAmericanShorthairData() => _createPlaceholderBreed("american_shorthair", "American Shorthair", "United States", "Shorthair");
  static Map<String, dynamic> _generateScottishFoldData() => _createPlaceholderBreed("scottish_fold", "Scottish Fold", "Scotland", "Shorthair");
  static Map<String, dynamic> _generateOrientalShorthairData() => _createPlaceholderBreed("oriental_shorthair", "Oriental Shorthair", "Thailand", "Oriental");
  static Map<String, dynamic> _generateDevonRexData() => _createPlaceholderBreed("devon_rex", "Devon Rex", "England", "Rex");
  static Map<String, dynamic> _generateCornishRexData() => _createPlaceholderBreed("cornish_rex", "Cornish Rex", "England", "Rex");
  static Map<String, dynamic> _generateBirmanData() => _createPlaceholderBreed("birman", "Birman", "Myanmar", "Semi-longhair");
  static Map<String, dynamic> _generateTonkineseData() => _createPlaceholderBreed("tonkinese", "Tonkinese", "Canada", "Oriental");
  static Map<String, dynamic> _generateOcicatData() => _createPlaceholderBreed("ocicat", "Ocicat", "United States", "Spotted");
  static Map<String, dynamic> _generateAmericanCurlData() => _createPlaceholderBreed("american_curl", "American Curl", "United States", "Curl");
  static Map<String, dynamic> _generateManxData() => _createPlaceholderBreed("manx", "Manx", "Isle of Man", "Tailless");
  static Map<String, dynamic> _generateExoticShorthairData() => _createPlaceholderBreed("exotic_shorthair", "Exotic Shorthair", "United States", "Shorthair");
  static Map<String, dynamic> _generateChartreuData() => _createPlaceholderBreed("chartreux", "Chartreux", "France", "Shorthair");
  static Map<String, dynamic> _generateKoratData() => _createPlaceholderBreed("korat", "Korat", "Thailand", "Shorthair");
  static Map<String, dynamic> _generateBombayData() => _createPlaceholderBreed("bombay", "Bombay", "United States", "Shorthair");
  static Map<String, dynamic> _generateBalineseData() => _createPlaceholderBreed("balinese", "Balinese", "United States", "Longhair");
  static Map<String, dynamic> _generateJapaneseBobtailData() => _createPlaceholderBreed("japanese_bobtail", "Japanese Bobtail", "Japan", "Bobtail");
  static Map<String, dynamic> _generateEgyptianMauData() => _createPlaceholderBreed("egyptian_mau", "Egyptian Mau", "Egypt", "Spotted");
  static Map<String, dynamic> _generateSingapuraData() => _createPlaceholderBreed("singapura", "Singapura", "Singapore", "Shorthair");
  static Map<String, dynamic> _generateSomaliData() => _createPlaceholderBreed("somali", "Somali", "Somalia", "Longhair");
  static Map<String, dynamic> _generateHavanaData() => _createPlaceholderBreed("havana", "Havana Brown", "United Kingdom", "Shorthair");
  static Map<String, dynamic> _generateAmericanBobtailData() => _createPlaceholderBreed("american_bobtail", "American Bobtail", "United States", "Bobtail");
  static Map<String, dynamic> _generateSelkirkRexData() => _createPlaceholderBreed("selkirk_rex", "Selkirk Rex", "United States", "Rex");
  static Map<String, dynamic> _generateLaPermData() => _createPlaceholderBreed("laperm", "LaPerm", "United States", "Rex");
  static Map<String, dynamic> _generateMunchkinData() => _createPlaceholderBreed("munchkin", "Munchkin", "United States", "Dwarf");
  static Map<String, dynamic> _generateSavannahData() => _createPlaceholderBreed("savannah", "Savannah", "United States", "Hybrid");
  static Map<String, dynamic> _generateToygerData() => _createPlaceholderBreed("toyger", "Toyger", "United States", "Striped");
  static Map<String, dynamic> _generatePixiebobData() => _createPlaceholderBreed("pixiebob", "Pixiebob", "United States", "Bobtail");
  static Map<String, dynamic> _generateHighlanderData() => _createPlaceholderBreed("highlander", "Highlander", "United States", "Curl");
  static Map<String, dynamic> _generateChausieData() => _createPlaceholderBreed("chausie", "Chausie", "United States", "Hybrid");
  static Map<String, dynamic> _generateKurilianBobtailData() => _createPlaceholderBreed("kurilian_bobtail", "Kurilian Bobtail", "Russia", "Bobtail");
  static Map<String, dynamic> _generatePeterbaldData() => _createPlaceholderBreed("peterbald", "Peterbald", "Russia", "Hairless");
  static Map<String, dynamic> _generateDonskoyData() => _createPlaceholderBreed("donskoy", "Donskoy", "Russia", "Hairless");
  static Map<String, dynamic> _generateLykoiData() => _createPlaceholderBreed("lykoi", "Lykoi", "United States", "Hairless");
  static Map<String, dynamic> _generateNebelungData() => _createPlaceholderBreed("nebelung", "Nebelung", "United States", "Longhair");
  static Map<String, dynamic> _generateTurkishAngoraData() => _createPlaceholderBreed("turkish_angora", "Turkish Angora", "Turkey", "Longhair");
  static Map<String, dynamic> _generateSnowshoeData() => _createPlaceholderBreed("snowshoe", "Snowshoe", "United States", "Pointed");
  static Map<String, dynamic> _generateBurmillaData() => _createPlaceholderBreed("burmilla", "Burmilla", "United Kingdom", "Shorthair");
  static Map<String, dynamic> _generateBurmeseData() => _createPlaceholderBreed("burmese", "Burmese", "Myanmar", "Shorthair");
  static Map<String, dynamic> _generateAustralianMistData() => _createPlaceholderBreed("australian_mist", "Australian Mist", "Australia", "Shorthair");
  static Map<String, dynamic> _generateAmericanWirehairData() => _createPlaceholderBreed("american_wirehair", "American Wirehair", "United States", "Wirehair");
  static Map<String, dynamic> _generateMinuetData() => _createPlaceholderBreed("minuet", "Minuet", "United States", "Dwarf");
  static Map<String, dynamic> _generateSerengetiData() => _createPlaceholderBreed("serengeti", "Serengeti", "United States", "Spotted");
  static Map<String, dynamic> _generateThaiData() => _createPlaceholderBreed("thai", "Thai", "Thailand", "Pointed");
  static Map<String, dynamic> _generateToybobData() => _createPlaceholderBreed("toybob", "Toybob", "Russia", "Bobtail");
  static Map<String, dynamic> _generateTennesseeRexData() => _createPlaceholderBreed("tennessee_rex", "Tennessee Rex", "United States", "Rex");
  static Map<String, dynamic> _generateKhaomaneeData() => _createPlaceholderBreed("khaomanee", "Khao Manee", "Thailand", "Shorthair");
  static Map<String, dynamic> _generateCymricData() => _createPlaceholderBreed("cymric", "Cymric", "Isle of Man", "Longhair");
  static Map<String, dynamic> _generateCherubimData() => _createPlaceholderBreed("cherubim", "Cherubim", "United States", "Longhair");
  static Map<String, dynamic> _generateHimalayanData() => _createPlaceholderBreed("himalayan", "Himalayan", "United States", "Longhair");

  /// Creates a placeholder breed with basic information
  static Map<String, dynamic> _createPlaceholderBreed(String id, String name, String origin, String breedGroup) {
    return {
      "id": id,
      "name": name,
      "aliases": ["${name} Cat"],
      "origin": origin,
      "breed_group": breedGroup,
      "is_crossbreed": false,
      "crossbreed_info": null,
      "recognition": [
        {"organization": "TICA", "status": "recognized"}
      ],
      "history": "Comprehensive historical information about the $name breed to be added.",
      "appearance": {
        "body_type": "Medium",
        "weight_range": "8-12 lbs",
        "average_height": "20-25 cm",
        "coat_length": "Short",
        "coat": "Short coat",
        "coat_colors": ["Various"],
        "colors": "Various colors",
        "eye_colors": ["Various"],
        "size": "Medium",
        "distinctive_features": ["Breed-specific features"],
        "distinct_features": ["Distinctive traits"]
      },
      "temperament": {
        "summary": "Detailed temperament description for $name cats to be added.",
        "traits": ["Friendly", "Intelligent"],
        "activity_level": "Medium",
        "vocalization_level": "Medium",
        "affection_level": "Medium",
        "intelligence": "Medium",
        "social_with_kids": true,
        "social_with_dogs": true,
        "social_with_cats": true,
        "trainability": "Medium"
      },
      "care": {
        "grooming_needs": "Moderate",
        "grooming": "Regular grooming needed",
        "shedding": "Moderate",
        "exercise_needs": "Moderate",
        "exercise": "Regular exercise needed",
        "dietary_notes": "Standard diet",
        "nutrition": "High-quality diet recommended"
      },
      "health": {
        "lifespan": "12–15 years",
        "common_issues": ["General health issues"],
        "genetic_tests": [],
        "veterinary_recommendations": "Regular health check-ups",
        "vaccinations": "Core vaccines per vet schedule"
      },
      "common_medications": [],
      "veterinary_care_recommendations": {
        "deworming_schedule": "Every 3 months",
        "vaccinations": "Annual core vaccines",
        "dental_care": "Regular dental care",
        "parasite_prevention": "Year-round prevention",
        "special_screenings": "Regular health screenings"
      },
      "breeding_compatibility": {
        "compatible_breeds": [],
        "genetic_precautions": []
      },
      "typical_litter_size": {
        "min": 2,
        "max": 6,
        "average": 4
      },
      "gestation_period_days": {
        "min": 63,
        "max": 67,
        "average": 65
      },
      "reproductive_maturity_age": {
        "male_months": 8,
        "female_months": 6
      },
      "life_span_years": {
        "min": 12,
        "max": 15,
        "average": 13
      },
      "weight_range_lbs": {
        "male": "10-14",
        "female": "8-12"
      },
      "other_traits": "Additional breed traits to be added",
      "breed_standard_links": [],
      "fun_facts": [
        "Interesting facts about $name breed to be added"
      ],
      "images": [],
      "videos": [],
      "adoption_resources": [],
      "related_breeds": [],
      "status": "Extant",
      "last_updated": "2024-12-18T00:00:00Z"
    };
  }
}
