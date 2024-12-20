ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif

CPP_SRC_DIR=./src/
HDL_SRC_DIR=../hdl/


loader:
	@echo "-- LLC AC TxMilLoader VERILATE & BUILD --------"
	$(VERILATOR) -cc --exe --trace --build -j $(HDL_SRC_DIR)Loader.v $(CPP_SRC_DIR)Loader.cpp -y $(HDL_SRC_DIR)
	@echo "-- RUN ---------------------"
	obj_dir/VLLC_AC_TxMilLoader
	@echo "-- DONE --------------------"