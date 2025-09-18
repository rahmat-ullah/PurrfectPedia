import 'dart:io';
import 'dart:convert';

void main() async {
  // Read the current JSON file
  final file = File('assets/data/breeds_data_structure.json');
  final jsonString = await file.readAsString();
  final List<dynamic> breeds = json.decode(jsonString);

  // Define image data for all breeds
  final Map<String, List<Map<String, String>>> breedImages = {
    'sphynx': [
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/e/e8/Sphinx2_July_2006.jpg',
        'caption': 'Sphynx cat showing the breed\'s hairless appearance and wrinkled skin'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Sphynx_cat_profile.jpg',
        'caption': 'Sphynx profile displaying large ears and angular features'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/6/6c/Sphynx_cat_eyes.jpg',
        'caption': 'Close-up of Sphynx eyes showing their lemon-shaped form'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Sphynx_kitten.jpg',
        'caption': 'Sphynx kitten with characteristic wrinkled skin'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/8/8e/Sphynx_cat_colors.jpg',
        'caption': 'Sphynx showing various skin colors and patterns'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/d/d5/Sphynx_cat_sitting.jpg',
        'caption': 'Sphynx sitting, demonstrating their muscular build'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Sphynx_cat_warm.jpg',
        'caption': 'Sphynx cat seeking warmth, showing their temperature-sensitive nature'
      }
    ],
    'russian_blue': [
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Russian_blue_cat.jpg',
        'caption': 'Russian Blue showing the breed\'s distinctive blue-gray coat and green eyes'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/e/e3/Russian_Blue_profile.jpg',
        'caption': 'Russian Blue profile displaying the breed\'s elegant build'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/a/a7/Russian_Blue_eyes.jpg',
        'caption': 'Close-up of Russian Blue\'s striking green eyes'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/9/9f/Russian_Blue_kitten.jpg',
        'caption': 'Russian Blue kitten with developing coat color'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Russian_Blue_sitting.jpg',
        'caption': 'Russian Blue sitting, showing their graceful posture'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/d/d2/Russian_Blue_coat.jpg',
        'caption': 'Russian Blue coat texture showing the breed\'s double coat'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/b/b8/Russian_Blue_full_body.jpg',
        'caption': 'Full body shot of Russian Blue showing their medium build'
      }
    ],
    'sphynx': [
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/e/e8/Sphinx2_July_2006.jpg',
        'caption': 'Sphynx cat showing the breed\'s hairless appearance and wrinkled skin'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Sphynx_cat_profile.jpg',
        'caption': 'Sphynx profile displaying large ears and angular features'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/6/6c/Sphynx_cat_eyes.jpg',
        'caption': 'Close-up of Sphynx eyes showing their lemon-shaped form'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Sphynx_kitten.jpg',
        'caption': 'Sphynx kitten with characteristic wrinkled skin'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/8/8e/Sphynx_cat_colors.jpg',
        'caption': 'Sphynx showing various skin colors and patterns'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/d/d5/Sphynx_cat_sitting.jpg',
        'caption': 'Sphynx sitting, demonstrating their muscular build'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Sphynx_cat_warm.jpg',
        'caption': 'Sphynx cat seeking warmth, showing their temperature-sensitive nature'
      }
    ],
    'norwegian_forest': [
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Norwegian_forest_cat.jpg',
        'caption': 'Norwegian Forest Cat showing the breed\'s thick double coat and large size'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/b/b4/Norwegian_Forest_Cat_brown_tabby.jpg',
        'caption': 'Brown tabby Norwegian Forest Cat with distinctive markings'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/7/7a/Norwegian_Forest_Cat_silver.jpg',
        'caption': 'Silver Norwegian Forest Cat showing coat color variation'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/e/e1/Norwegian_Forest_Cat_profile.jpg',
        'caption': 'Norwegian Forest Cat profile showing triangular head shape'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/9/9c/Norwegian_Forest_Cat_kitten.jpg',
        'caption': 'Norwegian Forest Cat kitten with developing coat'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/a/a8/Norwegian_Forest_Cat_climbing.jpg',
        'caption': 'Norwegian Forest Cat climbing, showing their natural agility'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/5/5f/Norwegian_Forest_Cat_eyes.jpg',
        'caption': 'Close-up of Norwegian Forest Cat\'s expressive eyes'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/d/d3/Norwegian_Forest_Cat_winter.jpg',
        'caption': 'Norwegian Forest Cat in winter, showing their cold-weather adaptation'
      }
    ],
    'siberian': [
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/3/3b/Siberian_cat.jpg',
        'caption': 'Siberian cat showing the breed\'s robust build and thick coat'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/c/c7/Siberian_cat_brown_tabby.jpg',
        'caption': 'Brown tabby Siberian with traditional markings'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Siberian_cat_silver.jpg',
        'caption': 'Silver Siberian showing coat color variation'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/8/8d/Siberian_cat_profile.jpg',
        'caption': 'Siberian profile displaying the breed\'s rounded features'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/f/f5/Siberian_kitten.jpg',
        'caption': 'Siberian kitten with fluffy coat and round eyes'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/2/2c/Siberian_cat_eyes.jpg',
        'caption': 'Close-up of Siberian\'s large, round eyes'
      },
      {
        'url': 'https://upload.wikimedia.org/wikipedia/commons/9/9a/Siberian_cat_winter.jpg',
        'caption': 'Siberian cat in winter, showing their cold-weather coat'
      }
    ]
  };

  // Update breeds with image data
  for (int i = 0; i < breeds.length; i++) {
    final breed = breeds[i] as Map<String, dynamic>;
    final breedId = breed['id'] as String;
    
    if (breedImages.containsKey(breedId)) {
      breed['images'] = breedImages[breedId];
      print('Updated images for $breedId');
    }
  }

  // Write back to file
  final updatedJson = JsonEncoder.withIndent('  ').convert(breeds);
  await file.writeAsString(updatedJson);
  
  print('Successfully updated breed images!');
}
