// Find the greatest common divisor of the two integers, n and m.
int gcd_recursive(int n, int m) {
  int p = n, q = m;
  if (m > n) {
    p = m;
    q = n;
  }

  if (q == 0) {
    return p;
  }

  return gcd_recursive(q, p % q);
}
