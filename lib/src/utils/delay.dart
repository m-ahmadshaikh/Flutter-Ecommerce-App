Future<void> delay(bool addDelay, [int miliseconds = 2000]) {
  if (addDelay) {
    return Future.delayed(Duration(milliseconds: miliseconds));
  } else {
    return Future.value();
  }
}
