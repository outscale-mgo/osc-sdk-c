all: example1 example2 example3 example0

osc_sdk.o:
	gcc -c osc_sdk.c `pkg-config --cflags json-c` $(CFLAGS)

osc_sdk.a: osc_sdk.o
	ar -crs osc_sdk.a osc_sdk.o

example0: osc_sdk.a osc_sdk.h examples/example0.c
	$(CC) examples/example0.c -I./ -o example0 -Wall -Wno-unused-function -g -std=c89 $(CFLAGS) ./osc_sdk.a $(LDFLAGS) -lcurl `pkg-config --libs json-c`

example1: osc_sdk.c osc_sdk.h examples/example1.c
	$(CC) examples/example1.c ./osc_sdk.c -I./ `pkg-config --cflags json-c`  -o example1 -Wall -Wno-unused-function -g $(CFLAGS) $(LDFLAGS) `pkg-config --libs json-c` -lcurl

example2: osc_sdk.c osc_sdk.h examples/example2.c
	$(CC) examples/example2.c ./osc_sdk.c -I./ `pkg-config --cflags json-c`  -o example2 -Wall -Wno-unused-function -g $(CFLAGS) $(LDFLAGS) `pkg-config --libs json-c` -lcurl

example3: osc_sdk.c osc_sdk.h examples/example3.c
	$(CC) examples/example3.c ./osc_sdk.c -I./ `pkg-config --cflags json-c`  -o example3 -Wall -Wno-unused-function -g $(CFLAGS) $(LDFLAGS) `pkg-config --libs json-c` -lcurl

COGNAC/.git:
	git submodule update --init

COGNAC/config.mk: COGNAC/.git
	cd COGNAC && ./configure $$COGNAC_CONFIG

COGNAC/osc_sdk.c: COGNAC/config.mk
	make -C COGNAC osc_sdk.c

COGNAC/osc_sdk.h: COGNAC/config.mk
	make -C COGNAC osc_sdk.h

regen: COGNAC/osc_sdk.c COGNAC/osc_sdk.h
	cp COGNAC/osc_sdk.c .
	cp COGNAC/osc_sdk.h .

clean:
	rm -rvf examples/*.o example0 example1 example2 example3

clean_sdk:
	rm -rvf COGNAC/

clean_all: clean clean_sdk

test: example0 example1 example2 example3
	./intergration-test.sh

.PHONY: clean clean_sdk clean_all all test regen
