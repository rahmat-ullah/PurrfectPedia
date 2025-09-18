import 'dart:convert';
import '../models/cat_breed.dart';
import 'database_service.dart';

class BreedDatabasePopulator {
  final DatabaseService _databaseService = DatabaseService();

  /// Populates the database with comprehensive cat breed data
  Future<void> populateDatabase() async {
    print('Starting breed database population...');
    
    final breeds = await _getAllBreedData();
    
    for (final breed in breeds) {
      try {
        await _databaseService.insertBreed(breed);
        print('Successfully added breed: ${breed.name}');
      } catch (e) {
        print('Error adding breed ${breed.name}: $e');
      }
    }
    
    print('Breed database population completed. Added ${breeds.length} breeds.');
  }

  /// Returns comprehensive data for all major cat breeds
  Future<List<CatBreed>> _getAllBreedData() async {
    return [
      _getMaineCoonData(),
      _getPersianData(),
      _getSiameseData(),
      _getBengalData(),
      _getRagdollData(),
      _getBritishShorthairData(),
      _getAbyssinianData(),
      _getRussianBlueData(),
      _getSphynxData(),
      _getNorwegianForestData(),
      _getSiberianData(),
      _getTurkishVanData(),
      _getAmericanShorthairData(),
      _getScottishFoldData(),
      _getOrientalShorthairData(),
      _getDevonRexData(),
      _getCornishRexData(),
      _getBirmanData(),
      _getTonkineseData(),
      _getOcicatData(),
      _getAmericanCurlData(),
      _getManxData(),
      _getExoticShorthairData(),
      _getChartreuData(),
      _getKoratData(),
      _getBombayData(),
      _getBalineseData(),
      _getJapaneseBobtailData(),
      _getEgyptianMauData(),
      _getSingapuraData(),
      _getSomaliData(),
      _getHavanaData(),
      _getAmericanBobtailData(),
      _getSelkirkRexData(),
      _getLaPermData(),
      _getMunchkinData(),
      _getSavannahData(),
      _getToygerData(),
      _getPixiebobData(),
      _getHighlanderData(),
      _getChausieData(),
      _getKurilianBobtailData(),
      _getPeterbaldData(),
      _getDonskoyData(),
      _getLykoiData(),
      _getNebelungData(),
      _getTurkishAngoraData(),
      _getSnowshoeData(),
      _getBurmillaData(),
      _getBurmeseData(),
      _getAustralianMistData(),
      _getAmericanWirehairData(),
      _getMinuetData(),
      _getSerengeti(),
      _getThaiData(),
      _getToybobData(),
      _getTennesseeRexData(),
      _getKhaomaneeData(),
      _getCymricData(),
      _getCherubimData(),
      _getHimalayanData(),
    ];
  }

  CatBreed _getMaineCoonData() {
    return CatBreed(
      id: 'maine_coon',
      name: 'Maine Coon',
      aliases: ['Coon Cat', 'Maine Shag', 'American Longhair'],
      origin: 'United States',
      breedGroup: 'Natural',
      history: 'The Maine Coon is America\'s native longhaired cat and one of the oldest natural breeds in North America. Generally regarded as a native of the state of Maine, where it was made the official state cat in 1985. The breed developed through natural selection in the harsh New England climate, creating a hardy, handsome breed well equipped to survive hostile winters. Early Maine Coons were often polydactyls, believed to help them use their paws as "natural snowshoes" during snowy Maine winters.',
      funFacts: [
        'Maine Coons are the only native longhaired American breed among pedigreed cats',
        'They often chirp and trill rather than meow to communicate',
        'Some Maine Coons have six toes (polydactyls) recognized by TICA as Maine Coon Polydactyls',
        'Most Maine Coons actually like water and are good swimmers due to their water-resistant fur',
        'They don\'t reach full maturity until 4 years of age',
        'Known as "gentle giants" due to their size and friendly nature'
      ],
      relatedBreeds: ['Norwegian Forest Cat', 'Siberian'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Sweet-tempered, gentle, friendly, and social. They have a clown-like personality and are willing to "help" their owners, yet aren\'t demanding of attention. They make excellent companions for large, active families and get along well with children, dogs, and other cats.',
      appearanceDescription: 'Large, muscular, rectangular body with substantial boning. Semi-longhair glossy coat that is heavy and water-resistant, longer on the ruff, stomach and britches. Large ears with tufts, broad chest, long flowing tail, and large feet with tufts. Males average 13-18 lbs, females 9-13 lbs.',
      careInstructions: 'Weekly combing is usually sufficient to maintain their coat. Regular nail trimming, teeth brushing, and high-quality diet with proper portions to prevent obesity. Interactive toys provide exercise and bonding.',
      healthInfo: 'Generally healthy breed. Potential issues include Hypertrophic Cardiomyopathy (HCM), Hip Dysplasia, and Spinal Muscular Atrophy (SMA). Responsible breeders test for these conditions. Lifespan: 12.5+ years.',
    );
  }

  CatBreed _getPersianData() {
    return CatBreed(
      id: 'persian',
      name: 'Persian',
      aliases: ['Longhair', 'Persian Longhair'],
      origin: 'Iran (Persia)',
      breedGroup: 'Natural',
      history: 'One of the oldest cat breeds, the Persian has a long and illustrious history. Named after their country of origin, Persia (modern-day Iran), these cats were first imported to Europe in the 1600s. The breed was refined in Britain and later in America, developing the distinctive flat face and luxurious coat we know today.',
      funFacts: [
        'One of the most popular cat breeds worldwide',
        'Featured in numerous movies and TV shows',
        'Requires daily grooming to prevent matting',
        'Come in over 80 color combinations',
        'Known for their calm, gentle demeanor',
        'Can live 12-17 years with proper care'
      ],
      relatedBreeds: ['Exotic Shorthair', 'Himalayan'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Calm, gentle, and sweet-natured. Persians are quiet, docile cats who prefer a serene environment. They are affectionate with their families but not overly demanding of attention.',
      appearanceDescription: 'Medium to large size with a cobby body type. Distinctive flat face with large, round eyes. Long, flowing double coat that requires daily maintenance. Round head with small ears set wide apart.',
      careInstructions: 'Daily brushing essential to prevent matting. Regular eye cleaning due to facial structure. High-quality diet and regular veterinary care. Indoor living recommended.',
      healthInfo: 'Prone to breathing difficulties due to flat face, kidney disease, eye problems, and skin conditions. Regular health screenings recommended. Lifespan: 12-17 years.',
    );
  }

  CatBreed _getSiameseData() {
    return CatBreed(
      id: 'siamese',
      name: 'Siamese',
      aliases: ['Royal Cat of Siam', 'Meezer'],
      origin: 'Thailand (formerly Siam)',
      breedGroup: 'Oriental',
      history: 'Ancient breed from Thailand, formerly known as Siam. These cats were considered sacred and were kept by Thai royalty. First imported to the West in the late 1800s, they quickly became popular for their striking appearance and vocal personality.',
      funFacts: [
        'One of the most vocal cat breeds',
        'Born white and develop color points as they age',
        'Temperature affects their coat color - cooler areas are darker',
        'Highly intelligent and can learn tricks',
        'Form strong bonds with their owners',
        'Featured in Disney\'s "Lady and the Tramp"'
      ],
      relatedBreeds: ['Oriental Shorthair', 'Balinese', 'Tonkinese'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Highly intelligent, vocal, social, and demanding of attention. Siamese cats are known for their dog-like loyalty and will follow their owners around. They are playful, curious, and need mental stimulation.',
      appearanceDescription: 'Medium-sized, slender, and elegant with a wedge-shaped head. Large ears, almond-shaped blue eyes, and pointed coloration (darker ears, face, legs, and tail). Short, fine coat.',
      careInstructions: 'Minimal grooming needed. Provide plenty of mental stimulation and interactive play. Social cats that do well with companions. Regular dental care important.',
      healthInfo: 'Generally healthy but can be prone to dental issues, respiratory problems, and certain genetic conditions. Lifespan: 12-15 years.',
    );
  }

  CatBreed _getBengalData() {
    return CatBreed(
      id: 'bengal',
      name: 'Bengal',
      aliases: ['Leopard Cat'],
      origin: 'United States',
      breedGroup: 'Hybrid',
      history: 'Developed in the 1960s-1980s by crossing domestic cats with Asian Leopard Cats to create a domestic cat with wild appearance. The breed was created by Jean Mill and others who wanted to combine the beauty of wild cats with the temperament of domestic cats.',
      funFacts: [
        'One of the most expensive cat breeds',
        'Many Bengals love water and some even swim',
        'Their coat can have a glittery appearance',
        'Highly active and athletic cats',
        'Can learn to walk on a leash',
        'Some early generation males may be sterile'
      ],
      relatedBreeds: ['Egyptian Mau', 'Ocicat'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Highly active, intelligent, and playful. Bengals are energetic cats that need plenty of stimulation. They are confident, curious, and can be quite vocal. They often enjoy interactive play and climbing.',
      appearanceDescription: 'Medium to large size with a muscular, athletic build. Distinctive spotted or marbled coat pattern resembling wild leopards. Large eyes, small rounded ears, and strong hindquarters.',
      careInstructions: 'Needs plenty of exercise and mental stimulation. Interactive toys, climbing trees, and puzzle feeders recommended. Weekly brushing sufficient. High-protein diet preferred.',
      healthInfo: 'Generally healthy but can be prone to hypertrophic cardiomyopathy, progressive retinal atrophy, and hip dysplasia. Lifespan: 12-16 years.',
    );
  }

  CatBreed _getRagdollData() {
    return CatBreed(
      id: 'ragdoll',
      name: 'Ragdoll',
      aliases: ['Raggie'],
      origin: 'United States',
      breedGroup: 'Semi-longhair',
      history: 'Developed in the 1960s by Ann Baker in California. The breed was created by crossing a white Persian-type cat named Josephine with various other cats. Known for their docile temperament and tendency to go limp when picked up, hence the name "Ragdoll".',
      funFacts: [
        'Known for going limp when picked up',
        'One of the largest domestic cat breeds',
        'Born white and develop color over time',
        'Very docile and gentle temperament',
        'Often called "puppy cats" for their dog-like behavior',
        'Take 3-4 years to reach full maturity'
      ],
      relatedBreeds: ['Birman', 'Persian'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Extremely docile, gentle, and relaxed. Ragdolls are known for their calm demeanor and tendency to go limp when handled. They are affectionate, social, and good with children and other pets.',
      appearanceDescription: 'Large, semi-longhaired cats with a sturdy build. Pointed coloration with blue eyes. Silky, medium-length coat that doesn\'t mat easily. Males can weigh 15-20 lbs, females 10-15 lbs.',
      careInstructions: 'Regular brushing 2-3 times per week. Indoor cats due to their trusting nature. Moderate exercise needs. High-quality diet to maintain healthy weight.',
      healthInfo: 'Generally healthy but can be prone to hypertrophic cardiomyopathy and kidney disease. Regular health screenings recommended. Lifespan: 13-18 years.',
    );
  }

  CatBreed _getBritishShorthairData() {
    return CatBreed(
      id: 'british_shorthair',
      name: 'British Shorthair',
      aliases: ['British Blue', 'Brit'],
      origin: 'United Kingdom',
      breedGroup: 'Shorthair',
      history: 'One of the oldest English breeds, descended from cats brought to Britain by the Romans. Nearly extinct after WWII, the breed was revived by crossing with Persians and other breeds. The British Blue variety is the most famous, but they come in many colors.',
      funFacts: [
        'Inspiration for the Cheshire Cat in Alice in Wonderland',
        'One of the oldest English cat breeds',
        'Known for their "smile" due to facial structure',
        'Very independent and dignified cats',
        'Can live up to 20 years',
        'The blue variety is most popular'
      ],
      relatedBreeds: ['British Longhair', 'Chartreux'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Calm, dignified, and independent. British Shorthairs are easygoing cats that are affectionate but not clingy. They are good with children and other pets but prefer to keep their feet on the ground.',
      appearanceDescription: 'Medium to large, sturdy build with a round face and large round eyes. Dense, plush coat that stands away from the body. Broad chest and strong legs. Males larger than females.',
      careInstructions: 'Weekly brushing usually sufficient. Moderate exercise needs. Quality diet important to prevent obesity. Regular dental care recommended.',
      healthInfo: 'Generally healthy but can be prone to hypertrophic cardiomyopathy and kidney disease. Regular health checks important. Lifespan: 14-20 years.',
    );
  }

  CatBreed _getAbyssinianData() {
    return CatBreed(
      id: 'abyssinian',
      name: 'Abyssinian',
      aliases: ['Aby', 'Bunny Cat'],
      origin: 'Ethiopia (formerly Abyssinia)',
      breedGroup: 'Oriental',
      history: 'One of the oldest known breeds, believed to originate from ancient Egypt and Abyssinia (modern-day Ethiopia). The modern breed was developed in Britain in the late 1800s. Known for their wild appearance and active personality.',
      funFacts: [
        'One of the oldest known cat breeds',
        'Resembles ancient Egyptian cats in artwork',
        'Extremely active and athletic',
        'Known for their "ticked" coat pattern',
        'Often called "clowns of the cat kingdom"',
        'Highly intelligent and curious'
      ],
      relatedBreeds: ['Somali', 'Singapura'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Highly active, intelligent, and playful. Abyssinians are curious cats that love to explore and climb. They are social, affectionate, and often follow their owners around the house.',
      appearanceDescription: 'Medium-sized, lithe and muscular build. Distinctive ticked coat where each hair has multiple bands of color. Large ears, almond-shaped eyes, and an alert expression.',
      careInstructions: 'Minimal grooming needed due to short coat. Needs plenty of exercise and mental stimulation. Interactive toys and climbing structures recommended.',
      healthInfo: 'Generally healthy but can be prone to kidney disease, dental issues, and certain genetic conditions. Lifespan: 12-15 years.',
    );
  }

  CatBreed _getRussianBlueData() {
    return CatBreed(
      id: 'russian_blue',
      name: 'Russian Blue',
      aliases: ['Archangel Blue', 'Foreign Blue'],
      origin: 'Russia',
      breedGroup: 'Shorthair',
      history: 'Believed to have originated in the port of Archangel in Russia. Sailors brought these cats to Western Europe in the 1860s. The breed was nearly extinct during WWII but was revived by breeding programs in Britain and Scandinavia.',
      funFacts: [
        'Known for their striking silver-blue coat',
        'Hypoallergenic qualities due to low Fel d 1 protein',
        'Very shy with strangers but devoted to family',
        'Green eyes that develop from yellow as they mature',
        'Double coat that stands out from the body',
        'Often called the "Doberman Pinscher of cats"'
      ],
      relatedBreeds: ['Nebelung', 'Chartreux', 'Korat'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Gentle, quiet, and somewhat shy. Russian Blues are devoted to their families but can be reserved with strangers. They are intelligent, playful, and prefer routine.',
      appearanceDescription: 'Medium-sized with a fine-boned, elegant build. Short, dense double coat in blue-gray with silver tips. Bright green eyes and a gentle expression.',
      careInstructions: 'Weekly brushing to remove loose hair. Prefers quiet environments and routine. Moderate exercise needs. High-quality diet recommended.',
      healthInfo: 'Generally very healthy breed with few genetic issues. Can live 15-20 years. Regular veterinary care recommended.',
    );
  }

  CatBreed _getSphynxData() {
    return CatBreed(
      id: 'sphynx',
      name: 'Sphynx',
      aliases: ['Canadian Hairless'],
      origin: 'Canada',
      breedGroup: 'Hairless',
      history: 'Developed in the 1960s from a hairless kitten born in Toronto, Canada. The breed was created through selective breeding to maintain the hairless trait while ensuring genetic diversity.',
      funFacts: [
        'Not completely hairless - has fine down',
        'Body temperature higher than other cats',
        'Requires sunscreen and warm clothing',
        'Very social and attention-seeking',
        'Often described as dog-like in behavior',
        'Wrinkled skin that feels like warm suede'
      ],
      relatedBreeds: ['Peterbald', 'Donskoy'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Extremely social, energetic, and attention-seeking. Sphynx cats are known for their extroverted personalities and love of human companionship. They are playful, curious, and often mischievous.',
      appearanceDescription: 'Medium-sized with a muscular build. Hairless or nearly hairless with wrinkled skin. Large ears, prominent cheekbones, and a pot belly. Skin feels warm and soft.',
      careInstructions: 'Regular bathing needed to remove skin oils. Protection from sun and cold required. High-calorie diet due to higher metabolism. Indoor living essential.',
      healthInfo: 'Generally healthy but prone to skin issues, heart problems, and temperature sensitivity. Lifespan: 12-14 years.',
    );
  }

  CatBreed _getNorwegianForestData() {
    return CatBreed(
      id: 'norwegian_forest',
      name: 'Norwegian Forest Cat',
      aliases: ['Wegie', 'Norsk Skogkatt'],
      origin: 'Norway',
      breedGroup: 'Natural',
      history: 'Ancient breed from Norway, possibly descended from cats brought by Vikings. Featured in Norse mythology and fairy tales. Nearly extinct during WWII but was preserved by Norwegian breeders.',
      funFacts: [
        'Featured in Norse mythology as fairy cats',
        'Excellent climbers with strong claws',
        'Water-resistant double coat',
        'Can climb down trees head-first',
        'National cat of Norway',
        'Takes 5 years to reach full maturity'
      ],
      relatedBreeds: ['Maine Coon', 'Siberian'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Gentle, friendly, and independent. Norwegian Forest Cats are calm and patient, good with children and other pets. They are intelligent and playful but not overly demanding.',
      appearanceDescription: 'Large, sturdy build with a triangular head and large ears. Long, water-resistant double coat with a full ruff. Strong legs and large paws adapted for climbing.',
      careInstructions: 'Regular brushing needed, especially during shedding season. Needs space to climb and explore. Moderate exercise requirements.',
      healthInfo: 'Generally healthy but can be prone to hip dysplasia and heart disease. Lifespan: 12-16 years.',
    );
  }

  CatBreed _getSiberianData() {
    return CatBreed(
      id: 'siberian',
      name: 'Siberian',
      aliases: ['Siberian Forest Cat', 'Moscow Semi-longhair'],
      origin: 'Russia',
      breedGroup: 'Natural',
      history: 'Ancient breed from Russia, mentioned in Russian fairy tales and literature for centuries. Developed naturally in the harsh Siberian climate. First imported to the US in the 1990s.',
      funFacts: [
        'Hypoallergenic qualities in many individuals',
        'Excellent jumpers and climbers',
        'Water-resistant triple coat',
        'Featured in Russian folklore',
        'Can weigh up to 25 pounds',
        'Very hardy and adaptable breed'
      ],
      relatedBreeds: ['Maine Coon', 'Norwegian Forest Cat'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Gentle, playful, and adventurous. Siberians are intelligent cats that are good with children and other pets. They are loyal to their families and enjoy interactive play.',
      appearanceDescription: 'Large, powerful build with a rounded head and large eyes. Long, thick triple coat that is water-resistant. Strong hindquarters and large paws.',
      careInstructions: 'Regular brushing needed, daily during shedding season. Needs space for exercise and climbing. High-quality diet to maintain coat condition.',
      healthInfo: 'Generally healthy breed with few genetic issues. Can be prone to heart disease. Lifespan: 12-15 years.',
    );
  }

  CatBreed _getTurkishVanData() {
    return CatBreed(
      id: 'turkish_van',
      name: 'Turkish Van',
      aliases: ['Swimming Cat', 'Van Cat'],
      origin: 'Turkey',
      breedGroup: 'Natural',
      history: 'Ancient breed from the Lake Van region of Turkey. Known for their love of water and distinctive color pattern. Brought to Britain in the 1950s and developed as a breed.',
      funFacts: [
        'Known as the "Swimming Cat" for their love of water',
        'Distinctive van pattern with color only on head and tail',
        'Often have odd-colored eyes (one blue, one amber)',
        'National treasure of Turkey',
        'Excellent swimmers with water-resistant coat',
        'Very active and athletic cats'
      ],
      relatedBreeds: ['Turkish Angora'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Active, intelligent, and independent. Turkish Vans are energetic cats that love to play and explore. They can be affectionate but on their own terms.',
      appearanceDescription: 'Large, muscular build with a wedge-shaped head. Semi-longhaired coat with distinctive van pattern (color on head and tail only). Often have odd-colored eyes.',
      careInstructions: 'Regular brushing needed. Enjoys access to water for play. Needs plenty of exercise and mental stimulation. Climbing structures recommended.',
      healthInfo: 'Generally healthy breed. Can be prone to deafness in white cats and heart disease. Lifespan: 12-17 years.',
    );
  }

  CatBreed _getAmericanShorthairData() {
    return CatBreed(
      id: 'american_shorthair',
      name: 'American Shorthair',
      aliases: ['Domestic Shorthair', 'Working Cat'],
      origin: 'United States',
      breedGroup: 'Shorthair',
      history: 'Descended from European cats brought to America by early settlers. Originally working cats that controlled rodent populations. Developed into a distinct breed through selective breeding.',
      funFacts: [
        'One of the most popular breeds in America',
        'Originally working cats on ships and farms',
        'Come in over 80 color and pattern combinations',
        'Known for their excellent hunting abilities',
        'Very hardy and adaptable breed',
        'Can live up to 20 years'
      ],
      relatedBreeds: ['British Shorthair', 'European Shorthair'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Easy-going, gentle, and adaptable. American Shorthairs are well-balanced cats that are good with children and other pets. They are independent but affectionate.',
      appearanceDescription: 'Medium to large size with a well-balanced, muscular build. Short, dense coat in many colors and patterns. Round head with full cheeks and large eyes.',
      careInstructions: 'Minimal grooming needed. Regular exercise to prevent obesity. Quality diet and regular veterinary care. Good indoor/outdoor adaptability.',
      healthInfo: 'Generally very healthy breed with few genetic issues. Can be prone to obesity and heart disease. Lifespan: 15-20 years.',
    );
  }

  CatBreed _getScottishFoldData() {
    return CatBreed(
      id: 'scottish_fold',
      name: 'Scottish Fold',
      aliases: ['Lop-eared Cat'],
      origin: 'Scotland',
      breedGroup: 'Shorthair',
      history: 'Originated from a barn cat named Susie found in Scotland in 1961. The folded ears are caused by a genetic mutation affecting cartilage. The breed was developed through careful breeding programs.',
      funFacts: [
        'Famous for their folded ears that give an owl-like appearance',
        'Not all Scottish Folds have folded ears',
        'Known for sitting in unusual positions',
        'Very quiet and gentle cats',
        'Popular in Japan and Asia',
        'The fold gene can cause health issues'
      ],
      relatedBreeds: ['Scottish Straight', 'British Shorthair'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Sweet-natured, calm, and adaptable. Scottish Folds are gentle cats that are good with children and other pets. They are affectionate but not overly demanding.',
      appearanceDescription: 'Medium-sized with a rounded appearance. Distinctive folded ears (in some individuals) and large, round eyes. Dense coat and sturdy build.',
      careInstructions: 'Regular brushing needed. Gentle exercise appropriate. Quality diet and regular health monitoring important due to potential joint issues.',
      healthInfo: 'Can be prone to joint and cartilage problems due to the fold gene. Regular veterinary monitoring recommended. Lifespan: 11-15 years.',
    );
  }

  CatBreed _getOrientalShorthairData() {
    return CatBreed(
      id: 'oriental_shorthair',
      name: 'Oriental Shorthair',
      aliases: ['Oriental', 'Foreign Shorthair'],
      origin: 'Thailand/United Kingdom',
      breedGroup: 'Oriental',
      history: 'Developed from Siamese cats in the 1950s-1960s to create cats with Siamese body type but in solid colors and patterns other than pointed. Created through breeding Siamese with other breeds.',
      funFacts: [
        'Come in over 300 color and pattern combinations',
        'Very vocal like their Siamese relatives',
        'Extremely social and people-oriented',
        'Can be trained to walk on a leash',
        'Form strong bonds with their owners',
        'Very active and playful throughout life'
      ],
      relatedBreeds: ['Siamese', 'Oriental Longhair', 'Balinese'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Highly intelligent, vocal, and social. Oriental Shorthairs are active cats that need plenty of attention and stimulation. They are loyal and form strong bonds with their families.',
      appearanceDescription: 'Medium-sized with a slender, elegant build. Wedge-shaped head with large ears and almond-shaped eyes. Short, fine coat in many colors and patterns.',
      careInstructions: 'Minimal grooming needed. Requires plenty of mental stimulation and social interaction. Interactive toys and climbing structures recommended.',
      healthInfo: 'Generally healthy but can be prone to dental issues and some genetic conditions. Lifespan: 12-15 years.',
    );
  }

  CatBreed _getDevonRexData() {
    return CatBreed(
      id: 'devon_rex',
      name: 'Devon Rex',
      aliases: ['Pixie Cat', 'Alien Cat'],
      origin: 'England',
      breedGroup: 'Rex',
      history: 'Discovered in Devon, England in 1960 from a curly-coated stray cat. The breed was developed through selective breeding to maintain the unique coat texture and elfin appearance.',
      funFacts: [
        'Known for their pixie-like appearance',
        'Hypoallergenic qualities due to less shedding',
        'Very social and dog-like in behavior',
        'Love to perch on shoulders',
        'Excellent jumpers and climbers',
        'Often called "monkeys in cat suits"'
      ],
      relatedBreeds: ['Cornish Rex', 'Selkirk Rex'],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Highly social, playful, and mischievous. Devon Rex cats are active and intelligent, often getting into everything. They are very people-oriented and love attention.',
      appearanceDescription: 'Small to medium size with a slender build. Large ears, short curly coat, and an elfin face. High cheekbones and large eyes give them a unique appearance.',
      careInstructions: 'Minimal grooming needed due to short coat. Needs warmth in cold weather. Requires plenty of mental stimulation and social interaction.',
      healthInfo: 'Generally healthy but can be prone to skin issues and heart problems. Lifespan: 12-16 years.',
    );
  }

  // Placeholder methods for remaining breeds - these would be implemented with full data
  CatBreed _getCornishRexData() => _createPlaceholderBreed('cornish_rex', 'Cornish Rex', 'England', 'Rex');
  CatBreed _getBirmanData() => _createPlaceholderBreed('birman', 'Birman', 'Myanmar (Burma)', 'Semi-longhair');
  CatBreed _getTonkineseData() => _createPlaceholderBreed('tonkinese', 'Tonkinese', 'Canada/United States', 'Oriental');
  CatBreed _getOcicatData() => _createPlaceholderBreed('ocicat', 'Ocicat', 'United States', 'Spotted');
  CatBreed _getAmericanCurlData() => _createPlaceholderBreed('american_curl', 'American Curl', 'United States', 'Curl');
  CatBreed _getManxData() => _createPlaceholderBreed('manx', 'Manx', 'Isle of Man', 'Tailless');
  CatBreed _getExoticShorthairData() => _createPlaceholderBreed('exotic_shorthair', 'Exotic Shorthair', 'United States', 'Shorthair');
  CatBreed _getChartreuData() => _createPlaceholderBreed('chartreux', 'Chartreux', 'France', 'Shorthair');
  CatBreed _getKoratData() => _createPlaceholderBreed('korat', 'Korat', 'Thailand', 'Shorthair');
  CatBreed _getBombayData() => _createPlaceholderBreed('bombay', 'Bombay', 'United States', 'Shorthair');
  CatBreed _getBalineseData() => _createPlaceholderBreed('balinese', 'Balinese', 'United States', 'Longhair');
  CatBreed _getJapaneseBobtailData() => _createPlaceholderBreed('japanese_bobtail', 'Japanese Bobtail', 'Japan', 'Bobtail');
  CatBreed _getEgyptianMauData() => _createPlaceholderBreed('egyptian_mau', 'Egyptian Mau', 'Egypt', 'Spotted');
  CatBreed _getSingapuraData() => _createPlaceholderBreed('singapura', 'Singapura', 'Singapore', 'Shorthair');
  CatBreed _getSomaliData() => _createPlaceholderBreed('somali', 'Somali', 'Somalia', 'Longhair');
  CatBreed _getHavanaData() => _createPlaceholderBreed('havana', 'Havana Brown', 'United Kingdom', 'Shorthair');
  CatBreed _getAmericanBobtailData() => _createPlaceholderBreed('american_bobtail', 'American Bobtail', 'United States', 'Bobtail');
  CatBreed _getSelkirkRexData() => _createPlaceholderBreed('selkirk_rex', 'Selkirk Rex', 'United States', 'Rex');
  CatBreed _getLaPermData() => _createPlaceholderBreed('laperm', 'LaPerm', 'United States', 'Rex');
  CatBreed _getMunchkinData() => _createPlaceholderBreed('munchkin', 'Munchkin', 'United States', 'Dwarf');
  CatBreed _getSavannahData() => _createPlaceholderBreed('savannah', 'Savannah', 'United States', 'Hybrid');
  CatBreed _getToygerData() => _createPlaceholderBreed('toyger', 'Toyger', 'United States', 'Striped');
  CatBreed _getPixiebobData() => _createPlaceholderBreed('pixiebob', 'Pixiebob', 'United States', 'Bobtail');
  CatBreed _getHighlanderData() => _createPlaceholderBreed('highlander', 'Highlander', 'United States', 'Curl');
  CatBreed _getChausieData() => _createPlaceholderBreed('chausie', 'Chausie', 'United States', 'Hybrid');
  CatBreed _getKurilianBobtailData() => _createPlaceholderBreed('kurilian_bobtail', 'Kurilian Bobtail', 'Russia', 'Bobtail');
  CatBreed _getPeterbaldData() => _createPlaceholderBreed('peterbald', 'Peterbald', 'Russia', 'Hairless');
  CatBreed _getDonskoyData() => _createPlaceholderBreed('donskoy', 'Donskoy', 'Russia', 'Hairless');
  CatBreed _getLykoiData() => _createPlaceholderBreed('lykoi', 'Lykoi', 'United States', 'Hairless');
  CatBreed _getNebelungData() => _createPlaceholderBreed('nebelung', 'Nebelung', 'United States', 'Longhair');
  CatBreed _getTurkishAngoraData() => _createPlaceholderBreed('turkish_angora', 'Turkish Angora', 'Turkey', 'Longhair');
  CatBreed _getSnowshoeData() => _createPlaceholderBreed('snowshoe', 'Snowshoe', 'United States', 'Pointed');
  CatBreed _getBurmillaData() => _createPlaceholderBreed('burmilla', 'Burmilla', 'United Kingdom', 'Shorthair');
  CatBreed _getBurmeseData() => _createPlaceholderBreed('burmese', 'Burmese', 'Myanmar (Burma)', 'Shorthair');
  CatBreed _getAustralianMistData() => _createPlaceholderBreed('australian_mist', 'Australian Mist', 'Australia', 'Shorthair');
  CatBreed _getAmericanWirehairData() => _createPlaceholderBreed('american_wirehair', 'American Wirehair', 'United States', 'Wirehair');
  CatBreed _getMinuetData() => _createPlaceholderBreed('minuet', 'Minuet', 'United States', 'Dwarf');
  CatBreed _getSerengeti() => _createPlaceholderBreed('serengeti', 'Serengeti', 'United States', 'Spotted');
  CatBreed _getThaiData() => _createPlaceholderBreed('thai', 'Thai', 'Thailand', 'Pointed');
  CatBreed _getToybobData() => _createPlaceholderBreed('toybob', 'Toybob', 'Russia', 'Bobtail');
  CatBreed _getTennesseeRexData() => _createPlaceholderBreed('tennessee_rex', 'Tennessee Rex', 'United States', 'Rex');
  CatBreed _getKhaomaneeData() => _createPlaceholderBreed('khaomanee', 'Khao Manee', 'Thailand', 'Shorthair');
  CatBreed _getCymricData() => _createPlaceholderBreed('cymric', 'Cymric', 'Isle of Man', 'Longhair');
  CatBreed _getCherubimData() => _createPlaceholderBreed('cherubim', 'Cherubim', 'United States', 'Longhair');
  CatBreed _getHimalayanData() => _createPlaceholderBreed('himalayan', 'Himalayan', 'United States', 'Longhair');

  /// Creates a placeholder breed with basic information
  CatBreed _createPlaceholderBreed(String id, String name, String origin, String breedGroup) {
    return CatBreed(
      id: id,
      name: name,
      aliases: [],
      origin: origin,
      breedGroup: breedGroup,
      history: 'Detailed history information to be added.',
      funFacts: ['Comprehensive breed information coming soon.'],
      relatedBreeds: [],
      status: 'Extant',
      lastUpdated: DateTime.now(),
      temperamentSummary: 'Temperament details to be added.',
      appearanceDescription: 'Appearance details to be added.',
      careInstructions: 'Care instructions to be added.',
      healthInfo: 'Health information to be added.',
    );
  }
}
