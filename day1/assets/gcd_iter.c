// Find the greatest common divisor of the two integers, n and m.
int compute_gcd(int n, int m) {
  // Let n be the smaller number.
  if (n > m) {
    int tmp = m;
    m = n;
    n = tmp;
  }
  int gcd = 1;
  int i = 1;
  while (i <= n) {
    if (n % i == 0 && m % i == 0)
      gcd = i;
    i++;
  }
  return gcd;
}
