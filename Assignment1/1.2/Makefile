CC      = mpicc
COPT    = -g -O3

LD      = $(CC)
LDFLAGS = $(COPT) 

all: src_nb.x src_b.x

%.x: %.o
	$(LD) $(LDFLAGS) $< -o $@

%.o: %.c 
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o *.x

