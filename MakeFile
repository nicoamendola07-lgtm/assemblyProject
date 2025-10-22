# type Makefile

# All you need to do is type `make` to build the program.
# Type `make clean` to delete the program so you can build it again.
# Type `./type type.s` to run it with its own source code.

CC =	gcc

PROG =	type
OBJS =	type.o

all: ${OBJS}
	${CC} ${LDFLAGS} -o ${PROG} ${OBJS}

clean:
	rm -f ${PROG} ${OBJS} ${PROG}.core
