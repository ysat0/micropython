include ../../py/mkenv.mk

CROSS = 0
TARGET = mpython
# qstr definitions (must come before including py.mk)
QSTR_DEFS = qstrdefsport.h

# include py core make definitions
include $(TOP)/py/py.mk

ifeq ($(CROSS), 1)
CROSS_COMPILE ?= rx-elf-
endif

INC += -I.
INC += -I$(TOP)
INC += -I$(BUILD)

ifeq ($(CROSS), 1)
CFLAGS_RX = -fsingle-precision-constant -Wdouble-promotion
CFLAGS = $(INC) -Wall -Werror -std=c99 -nostdlib $(CFLAGS_RX) $(COPT)
LIBC =  $(shell $(CROSS_COMPILE)gcc -print-file-name=libc.a)
LDFLAGS = -T rx62n.ld -Map=$@.map -L $(dir $(LIBC))
# --cref --gc-sections
else
CFLAGS = -m32 $(INC) -Wall -Werror -std=c99 $(COPT)
LDFLAGS = -m32 -Wl,-Map=$@.map,--cref -Wl,--gc-sections
endif

CSUPEROPT = -Os # save some code space

# Tune for Debugging or Optimization
ifeq ($(DEBUG), 1)
CFLAGS += -O0 -ggdb
else
CFLAGS += -Os -DNDEBUG
endif

LIBS = -l c

SRC_C = \
	main.c \
	uart_core.c \
	lib/utils/printf.c \
	lib/utils/stdout_helpers.c \
	lib/utils/pyexec.c \
	lib/libc/string0.c \
	lib/mp-readline/readline.c \
	$(BUILD)/_frozen_mpy.c

SRC_S = crt0.s

OBJ = $(PY_CORE_O) $(addprefix $(BUILD)/, $(SRC_C:.c=.o)) $(addprefix $(BUILD)/, $(SRC_S:.s=.o))

ifeq ($(CROSS), 1)
all: $(BUILD)/$(TARGET).bin
else
all: $(BUILD)/$(TARGET).elf
endif

$(BUILD)/_frozen_mpy.c: frozentest.mpy $(BUILD)/genhdr/qstrdefs.generated.h
	$(ECHO) "MISC freezing bytecode"
	$(Q)$(TOP)/tools/mpy-tool.py -f -q $(BUILD)/genhdr/qstrdefs.preprocessed.h -mlongint-impl=none $< > $@

$(BUILD)/$(TARGET).elf: $(OBJ)
	$(ECHO) "LINK $@"
	$(Q)$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)
	$(Q)$(SIZE) $@

$(BUILD)/$(TARGET).bin: $(BUILD)/$(TARGET).elf
	$(Q)$(OBJCOPY) -O binary -j .vector -j .text -j .data $^ $@

$(BUILD)/$(TARGET).srec: $(BUILD)/$(TARGET).elf
	$(Q)$(OBJCOPY) -O srec -j .vector -j .text -j .data $^ $@

include $(TOP)/py/mkrules.mk
