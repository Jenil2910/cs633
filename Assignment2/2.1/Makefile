CC      = mpicc
COPT    = -g -O3

LD      = $(CC)
LDFLAGS = $(COPT)

HF = ../hostfile
HL = ../hostlist

XEX = mpiexec

all: src.x

%.x: %.c
	$(LD) $(LDFLAGS) $< -o $@

%.o: %.c 
	$(CC) $(CFLAGS) -c $< -o $@

hostfile:
	../../scripts/gen_hfl.sh $(HL) $(HF)

clean:
	rm *.x

