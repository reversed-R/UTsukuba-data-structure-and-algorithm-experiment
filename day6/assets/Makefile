#CC = gcc
#CFLAGS = -g

all: main_dijkstra main_dijkstra_path main_floyd

main_dijkstra: main_dijkstra.o dijkstra_util.o

main_dijkstra_path: main_dijkstra_path.o dijkstra_util.o

main_floyd: main_floyd.o

clean:
	/bin/rm -f main_dijkstra main_dijkstra_path main_floyd *.o *~
