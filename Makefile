# The name of your project (used to name the compiled .hex file)
TARGET = $(notdir $(CURDIR))

# The teensy version to use, 30, 31, 35, 36, LC, or 40
TEENSY = 40

# Set to 24000000, 48000000, or 96000000 to set CPU core speed
#set the core speed based on teensy version
ifeq ($(TEENSY), 30)
	TEENSY_CORE_SPEED = 48000000
else ifeq ($(TEENSY), 31)
	TEENSY_CORE_SPEED = 48000000
else ifeq ($(TEENSY), 35)
	TEENSY_CORE_SPEED = 120000000
else ifeq ($(TEENSY), 36)
	TEENSY_CORE_SPEED = 180000000
else ifeq ($(TEENSY), LC)
	TEENSY_CORE_SPEED = 48000000
else ifeq ($(TEENSY), 40)
	TEENSY_CORE_SPEED = 600000000
else
	$(error Invalid setting for TEENSY)

TEENSY_CORE_SPEED = 48000000

# Some libraries will require this to be defined
# If you define this, you will break the default main.cpp
#ARDUINO = 10600

# configurable options
OPTIONS = -DUSB_SERIAL -DLAYOUT_US_ENGLISH

# directory to build in
BUILDDIR = $(abspath $(CURDIR)/build)

#************************************************************************
# Location of Teensyduino utilities, Toolchain, and Arduino Libraries.
# To use this makefile without Arduino, copy the resources from these
# locations and edit the pathnames.  The rest of Arduino is not needed.
#************************************************************************

ARDUINO_ROOT=/usr/local/lib/arduino

# path location for Teensy Loader, teensy_post_compile and teensy_reboot
TOOLSPATH = $(CURDIR)/tools
# TOOLSPATH = $(ARDUINO_ROOT)/hardware/tools

ifeq ($(OS),Windows_NT)
    $(error What is Win Dose?)
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Darwin)
        TOOLSPATH = /Applications/Arduino.app/Contents/Java/hardware/tools/
    endif
endif


#set corepath based on teensy version
ifeq ($(TEENSY), 30)
	COREPATH = teensy3
else ifeq ($(TEENSY), 31)
	COREPATH = teensy3
else ifeq ($(TEENSY), 35)
	COREPATH = teensy3
else ifeq ($(TEENSY), 36)
	COREPATH = teensy3
else ifeq ($(TEENSY), LC)
	COREPATH = teensy3
else ifeq ($(TEENSY), 40)
	COREPATH = teensy4
else
	$(error Invalid setting for TEENSY)
endif

# path location for Arduino libraries
LIBRARYPATH = libraries

# path location for the arm-none-eabi compiler
COMPILERPATH = $(TOOLSPATH)/arm/bin

#************************************************************************
# Settings below this point usually do not need to be edited
#************************************************************************

# CPPFLAGS = compiler options for C and C++
CPPFLAGS = -Wall -g -Os -mthumb -ffunction-sections -fdata-sections -nostdlib -MMD $(OPTIONS) -DTEENSYDUINO=124 -DF_CPU=$(TEENSY_CORE_SPEED) -Isrc -I$(COREPATH)

# compiler options for C++ only
CXXFLAGS = -std=gnu++0x -felide-constructors -fno-exceptions -fno-rtti

# compiler options for C only
CFLAGS =

# linker options
LDFLAGS = -Os -Wl,--gc-sections -mthumb

# additional libraries to link
LIBS = -lm

# compiler options specific to teensy version
ifeq ($(TEENSY), 30)
    CPPFLAGS += -D__MK20DX128__ -mcpu=cortex-m4
    MCU = mk20dx128
    LDSCRIPT = $(COREPATH)/$(MCU).ld
    LDFLAGS += -mcpu=cortex-m4 -T$(LDSCRIPT)
else ifeq ($(TEENSY), 31)
    CPPFLAGS += -D__MK20DX256__ -mcpu=cortex-m4
    MCU = mk20dx256
    LDSCRIPT = $(COREPATH)/$(MCU).ld
    LDFLAGS += -mcpu=cortex-m4 -T$(LDSCRIPT)
else ifeq ($(TEENSY), LC)
    CPPFLAGS += -D__MKL26Z64__ -mcpu=cortex-m0plus
    MCU = mkl26z64
    LDSCRIPT = $(COREPATH)/$(MCU).ld
    LDFLAGS += -mcpu=cortex-m0plus -T$(LDSCRIPT)
    LIBS += -larm_cortexM0l_math
else ifeq ($(TEENSY), 35)
    CPPFLAGS += -D__MK64FX512__ -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
    MCU = mk64fx512
    LDSCRIPT = $(COREPATH)/$(MCU).ld
    LDFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T$(LDSCRIPT)
    LIBS += -larm_cortexM4lf_math
else ifeq ($(TEENSY), 36)
    CPPFLAGS += -D__MK66FX1M0__ -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
    MCU = mk66fx1m0
    LDSCRIPT = $(COREPATH)/$(MCU).ld
    LDFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T$(LDSCRIPT)
    LIBS += -larm_cortexM4lf_math
else ifeq ($(TEENSY), 40)
	CPPFLAGS += -D__IMXRT1062__ -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-d16
	MCU = imxrt1062
	LDSCRIPT = $(COREPATH)/$(MCU).ld
	LDFLAGS += -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-d16 -T$(LDSCRIPT)
	LIBS += -larm_cortexM7lfsp_math
else
    $(error Invalid setting for TEENSY)
endif

#print out the compiler settings
$(info )
$(info Compiler Settings:)
$(info )
$(info CPPFLAGS: $(CPPFLAGS))
$(info CXXFLAGS: $(CXXFLAGS))
$(info CFLAGS: $(CFLAGS))
$(info LDFLAGS: $(LDFLAGS))
$(info LIBS: $(LIBS))
$(info )


# set arduino define if given
ifdef ARDUINO
	CPPFLAGS += -DARDUINO=$(ARDUINO)
else
	CPPFLAGS += -DUSING_MAKEFILE
endif

# names for the compiler programs
CC = $(abspath $(COMPILERPATH))/arm-none-eabi-gcc
CXX = $(abspath $(COMPILERPATH))/arm-none-eabi-g++
OBJCOPY = $(abspath $(COMPILERPATH))/arm-none-eabi-objcopy
SIZE = $(abspath $(COMPILERPATH))/arm-none-eabi-size

# automatically create lists of the sources and objects
LC_FILES := $(wildcard $(LIBRARYPATH)/*/*.c)
LCPP_FILES := $(wildcard $(LIBRARYPATH)/*/*.cpp)
TC_FILES := $(wildcard $(COREPATH)/*.c)
TCPP_FILES := $(wildcard $(COREPATH)/*.cpp)
C_FILES := $(wildcard src/*.c)
CPP_FILES := $(wildcard src/*.cpp)
INO_FILES := $(wildcard src/*.ino)

# include paths for libraries
L_INC := $(foreach lib,$(filter %/, $(wildcard $(LIBRARYPATH)/*/)), -I$(lib))

SOURCES := $(C_FILES:.c=.o) $(CPP_FILES:.cpp=.o) $(INO_FILES:.ino=.o) $(TC_FILES:.c=.o) $(TCPP_FILES:.cpp=.o) $(LC_FILES:.c=.o) $(LCPP_FILES:.cpp=.o)
OBJS := $(foreach src,$(SOURCES), $(BUILDDIR)/$(src))

all: hex loader

build: $(TARGET).elf

hex: $(TARGET).hex

# post_compile: $(TARGET).hex
# 	@$(abspath $(TOOLSPATH))/teensy_post_compile -file="$(basename $<)" -path=$(CURDIR) -tools="$(abspath $(TOOLSPATH))"

# reboot:
# 	@-$(abspath $(TOOLSPATH))/teensy_reboot

# upload: post_compile reboot

.PHONY: upload
upload: hex loader
	@$(LOADER) --mcu $(MCU) -w -s -v $(TARGET).hex

$(BUILDDIR)/%.o: %.c
	@echo -e "[CC]\t$<"
	@mkdir -p "$(dir $@)"
	@$(CC) $(CPPFLAGS) $(CFLAGS) $(L_INC) -o "$@" -c "$<"

$(BUILDDIR)/%.o: %.cpp
	@echo -e "[CXX]\t$<"
	@mkdir -p "$(dir $@)"
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(L_INC) -o "$@" -c "$<"

$(BUILDDIR)/%.o: %.ino
	@echo -e "[INO]\t$<"
	@mkdir -p "$(dir $@)"
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(L_INC) -o "$@" -x c++ -include Arduino.h -c "$<"

$(TARGET).elf: $(OBJS) $(LDSCRIPT)
	@echo -e "[LD]\t$@"
	@$(CC) $(LDFLAGS) -o "$@" $(OBJS) $(LIBS)

%.hex: %.elf
	@echo -e "[HEX]\t$@"
	@$(SIZE) "$<"
	@$(OBJCOPY) -O ihex -R .eeprom "$<" "$@"

# compiler generated dependency info
-include $(OBJS:.o=.d)

.PHONY: clean
clean:
	@echo Cleaning...
	@rm -rf "$(BUILDDIR)"
	@rm -f "$(TARGET).elf" "$(TARGET).hex"

	@rm -rf .teensy_loader_cli
	@rm -rf .make
	@rm -rf tools
	@rm -rf teensy3
	@rm -rf teensy4

#==================================#
#  arduino tools installation      #
#==================================#
arduino-tools: tools

tools:
	cp -r $(ARDUINO_ROOT)/hardware/tools tools

teensy3:
	cp -r $(ARDUINO_ROOT)/hardware/teensy/avr/cores/teensy3 teensy3
	# We'll supply our own main and can safely remove this
	rm teensy3/main.cpp


teensy4:
	cp -r $(ARDUINO_ROOT)/hardware/teensy/avr/cores/teensy4 teensy4
	# We'll supply our own main and can safely remove this
	rm teensy4/main.cpp

#==================================#
#  teensy_loader_cli installation  #
#==================================#

LOADER=bin/teensy_loader_cli
UDEV_RULES=/etc/udev/rules.d/49-teensy.rules

.PHONY: loader
loader: $(LOADER)

.make/loader-dependencies: .make
	sudo apt install libusb-dev
	@touch $@

$(UDEV_RULES):
	sudo wget -O $@ https://www.pjrc.com/teensy/49-teensy.rules

$(LOADER): .teensy_loader_cli/teensy_loader_cli | bin $(UDEV_RULES)
	cp $< $@

bin:
	mkdir -p bin

.teensy_loader_cli/teensy_loader_cli: .teensy_loader_cli | .make/loader-dependencies
	cd $< && make

.teensy_loader_cli:
	git clone https://github.com/PaulStoffregen/teensy_loader_cli $@

#=====================#
#  make marker files  #
#=====================#
.make:
	mkdir -p $@
