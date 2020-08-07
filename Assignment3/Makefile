CC      = mpicc
COPT    = -g -O3

LD      = $(CC)
LDFLAGS = $(COPT)
XEX = mpiexec

all: src.x

%.x: %.c
	$(LD) $(LDFLAGS) $< -o $@

%.o: %.c 
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.x

