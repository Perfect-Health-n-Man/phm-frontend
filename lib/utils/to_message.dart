String listToMessage(List<String> list) {
  return list.asMap().entries.map((entry) => "${entry.key + 1}. ${entry.value}").join("\n");
}