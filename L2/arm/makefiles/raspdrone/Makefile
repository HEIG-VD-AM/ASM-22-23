#############
# Toolchain #
#############

TOOL_PREFIX	:= arm-linux-gnueabihf

AR      = $(TOOL_PREFIX)-ar
LD      = $(TOOL_PREFIX)-ld
CC      = $(TOOL_PREFIX)-gcc
OBJCOPY	= $(TOOL_PREFIX)-objcopy

#########################################################################

#############
# Flags     #
#############

CFLAGS  = -I ./ -marm -g
LDFLAGS = -L. -ldriver

#########################################################################

#############
# Objects   #
#############

TARGET = raspdrone

SRCS_C = engine.c autopilot.c gyroscope.c motor.c navigation.c pwm.c camera.c
SRCS_S = crt0.S

OBJS_C = $(SRCS_C:.c=.o)
OBJS_S = $(SRCS_S:.S=.o)
OBJS = $(OBJS_C) $(OBJS_S)

LIB_OBJS = motor.o gyroscope.o camera.o
LIB = libdriver.a

#########################################################################

################
# Dependencies #
################

all: $(TARGET) $(TARGET).bin

$(TARGET): $(OBJS) $(LIB)
	$(LD) -o $@ $^ $(LDFLAGS) -T ./asm.lds

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

$(LIB): $(LIB_OBJS)
	$(AR) -r $@ $^
	
.PHONY: checklib
	checklib: $(LIB)

$(TARGET).bin: $(TARGET)
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f *.o raspdrone raspdrone.bin $(LIB)

autopilot.o: autopilot.h gyroscope.h navigation.h
camera.o: camera.h
gyroscope.o: gyroscope.h
motor.o: motor.h
navigation.o: navigation.h gyroscope.h camera.h
pwm.o: pwm.h
engine.o: motor.h autopilot.h camera.h gyroscope.h

