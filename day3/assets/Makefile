all: open_addressing open_addressing_test

open_addressing: open_addressing.o main_open_addressing.o

open_addressing_test: open_addressing.o main_open_addressing_test.o
	gcc open_addressing.o main_open_addressing_test.o -o open_addressing_test
