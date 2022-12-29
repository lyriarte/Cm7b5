

int fibonacci(int n)
{
	int fib;
	int fib0;
	int fib1;
	fib0 = 0;
	fib1 = 1;

	if (n < 2) {
		return n;
	}
	else {
		int i;
		i = 1;
		while (i < n) {
			fib = fib0 + fib1;
			fib0 = fib1;
			fib1 = fib;
			i = i + 1;
		}
	}
	return fib;
}

int main()
{
	return fibonacci(6);
}
