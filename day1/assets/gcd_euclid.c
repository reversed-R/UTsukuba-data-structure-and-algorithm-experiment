// Find the greatest common divisor of the two integers, n and m.
int gcd_euclid(int n, int m) {
  int p = n, q = m;
  while (1) {
    if (q > p) {
      int tmp = p;
      p = q;
      q = tmp;
    }

    if (q == 0) {
      return p;
    }

    int tmp = q;
    q = p % q;
    p = tmp;
  }

  return p;
}
