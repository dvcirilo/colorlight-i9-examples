# -------------------------------
# User configuration
# -------------------------------
TOP       = blink                 # Top-level module (without .sv/.v)
BUILD_DIR = build

# -------------------------------
# Toolchain
# -------------------------------
YOSYS     = yosys
NEXTPNR   = nextpnr-ecp5
ECPPACK   = ecppack
ECPDAP    = ecpdap
VERILATOR = verilator
GTKWAVE   = gtkwave

# -------------------------------
# Sources
# -------------------------------
SRCS      := rtl/*.sv           # Design files
TB        := tb/tb_$(TOP).sv            # SystemVerilog testbench
LPF 	  := fpga/$(TOP).lpf

# -------------------------------
# Outputs
# -------------------------------
JSON      := $(BUILD_DIR)/$(TOP).json
CFG       := $(BUILD_DIR)/$(TOP).config
BIT       := $(BUILD_DIR)/$(TOP).bit
SIM_EXE   := $(BUILD_DIR)/V$(TOP)
VCD       := $(BUILD_DIR)/$(TOP).vcd

# -------------------------------
# Default target
# -------------------------------
all: $(BIT).bit

# -------------------------------
# Yosys: synthesize to JSON
# -------------------------------
$(JSON).json: $(SRCS) | $(BUILD_DIR)
	$(YOSYS) -p "read_verilog -sv $(SRCS); synth_ecp5 -top $(TOP) -json $@"

# -------------------------------
# nextpnr: place & route
# -------------------------------
$(CFG).config: $(JSON).json
	$(NEXTPNR) --45k --package CABGA381 --speed 6 --json $< --textcfg $@ --lpf $(LPF).lpf --freq 65

# -------------------------------
# ecppack: bitstream
# -------------------------------
$(BIT).bit: $(CFG).config
	$(ECPPACK) --compress $< $@

# -------------------------------
# Flash via ecpdap
# -------------------------------
prog: $(BIT).bit
	$(ECPDAP) program --freq 5000 $<

# -------------------------------
# Simulation with Verilator
# -------------------------------
$(SIM_EXE): $(SRCS) $(TB) | $(BUILD_DIR)
	$(VERILATOR) -Wall --cc --exe --build $(SRCS) $(TB) --top-module tb_$(TOP) -o $@

sim: $(SIM_EXE)
	$(SIM_EXE)

# -------------------------------
# View waveforms
# -------------------------------
wave: $(VCD)
	$(GTKWAVE) $< &

# By default, Verilator testbenches generate a VCD dump if coded inside TB.
$(VCD): sim

# -------------------------------
# Helpers
# -------------------------------
$(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all prog sim wave clean
