class APIRequestCounter {
  static int calls = 0;
  static final debug = true;

  static incrementCalls(String description) {
    calls += 1;
    print("$description: $calls");
  }
}
