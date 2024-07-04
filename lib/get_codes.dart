List<int> generateCodes(String word1, String word2) {
  List<int> codes = List<int>.filled(word1.length, 0);
  //Map<String, int> countWord1 = countOccurrences(word1);
  Map<String, int> countWord2 = countOccurrences(word2);
  Map<String, int> usedInWord2 = {};

  // Initialize usedInWord2 counts to 0
  countWord2.forEach((char, _) {
    usedInWord2[char] = 0;
  });

  // First pass: assign codes for exact matches (code = 3)
  for (int i = 0; i < word1.length; i++) {
    if (word1[i] == word2[i]) {
      codes[i] = 3;
      usedInWord2[word1[i]] = (usedInWord2[word1[i]] ?? 0) + 1;
    } else {
      codes[i] = -1; // placeholder for now
    }
  }

  // Second pass: assign codes for non-exact matches
  for (int j = 0; j < word1.length; j++) {
    if (codes[j] == -1) {
      if (!countWord2.containsKey(word1[j])) {
        codes[j] = 0;
      } else if (usedInWord2[word1[j]]! < countWord2[word1[j]]!) {
        codes[j] = 1;
        usedInWord2[word1[j]] = usedInWord2[word1[j]]! + 1;
      } else {
        codes[j] = 2;
      }
    }
  }

  //debugPrint('Word1: $word1');
  //debugPrint('Word2: $word2');
  //debugPrint('Codes: $codes');

  return codes;
}

Map<String, int> countOccurrences(String word) {
  Map<String, int> count = {};
  for (int i = 0; i < word.length; i++) {
    String char = word[i];
    count[char] = (count[char] ?? 0) + 1;
  }
  return count;
}
