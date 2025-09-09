# -------------------------------
# Verilator Flags
# -------------------------------
VERILATOR_FLAGS += -Wall -Wno-fatal -j 0
VERILATOR_SIM_FLAGS += --binary --timing --trace-vcd --Mdir $(BUILDDIR)
VERILATOR_LINT_FLAGS += --lint-only

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
# Outputs
# -------------------------------
JSON      = $(BUILDDIR)/$(TOP)
CFG       = $(BUILDDIR)/$(TOP)
BIT       = $(BUILDDIR)/$(TOP)
SIM_EXE   = V$(TOP)
VCD       = $(BUILDDIR)/$(TOP)

# -------------------------------
# Default target
# -------------------------------
all: $(BIT).bit

# -------------------------------
# Yosys: synthesize to JSON
# -------------------------------
$(JSON).json: $(SRCS) | $(BUILDDIR)
	$(MAKE) lint
	$(YOSYS) -p "read_verilog -sv $(SRCS); synth_ecp5 -top $(TOP) -json $@"

# -------------------------------
# nextpnr: place & route
# -------------------------------
$(CFG).config: $(JSON).json
	$(NEXTPNR) --45k --package CABGA381 --speed 6 --json $< --textcfg $@ --lpf $(LPF) --freq 65

# -------------------------------
# ecppack: bitstream
# -------------------------------
$(BIT).bit: $(CFG).config
	$(ECPPACK) --compress $< $@

lint:
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_LINT_FLAGS) $(SRCS) --top-module $(TOP)
# -------------------------------
# Flash via ecpdap
# -------------------------------
prog: $(BIT).bit
	$(ECPDAP) program --freq 5000 $<

# -------------------------------
# Simulation with Verilator
# -------------------------------
$(SIM_EXE): $(SRCS) $(TB) | $(BUILDDIR)
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_SIM_FLAGS) $(SRCS) $(TB) --top-module tb_$(TOP) -o $@

sim: $(SIM_EXE)
	$(BUILDDIR)/$(SIM_EXE)

# -------------------------------
# View waveforms
# -------------------------------
wave: $(VCD).vcd
	$(GTKWAVE) $< &

# By default, Verilator testbenches generate a VCD dump if coded inside TB.
$(VCD).vcd: sim

# -------------------------------
# Helpers
# -------------------------------
$(BUILDDIR):
	mkdir -p $@

clean:
	rm -rf $(BUILDDIR)

.PHONY: all prog sim wave clean
