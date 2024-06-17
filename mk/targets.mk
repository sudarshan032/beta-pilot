# mk/targets.mk

# List of all possible targets
BASE_TARGETS := STM32F405

.PHONY: $(BASE_TARGETS) help

# Include tools.mk to ensure all tools and variables are available
include $(MAKE_SCRIPT_DIR)/tools.mk

# Define target MCUs
STM32F405_TARGET_MCU := STM32F405
STM32F7_TARGET_MCU := STM32F745

# Default target rule
$(BASE_TARGETS):
	@echo "Building target $@..."
	$(MAKE) -f $(ROOT)/Makefile TARGET=$@ TARGET_MCU=$(@:_TARGET_MCU)

help:
	@echo "Supported targets:"
	@for target in $(BASE_TARGETS); do echo "  $$target"; done

