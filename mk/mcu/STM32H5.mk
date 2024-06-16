#
# H5 Make file include
#

ifeq ($(DEBUG_HARDFAULTS),H5)
CFLAGS          += -DDEBUG_HARDFAULTS
endif

#CMSIS
CMSIS_DIR      := $(ROOT)/lib/main/CMSIS

#STDPERIPH
STDPERIPH_DIR   = $(ROOT)/lib/main/STM32H5/Drivers/STM32H5xx_HAL_Driver
STDPERIPH_SRC   = \
            stm32h5xx_hal_adc.c \
            stm32h5xx_hal_adc_ex.c \
            stm32h5xx_hal.c \
            stm32h5xx_hal_cordic.c \
            stm32h5xx_hal_cortex.c \
            stm32h5xx_hal_dac.c \
            stm32h5xx_hal_dac_ex.c \
            stm32h5xx_hal_dcache.c \
            stm32h5xx_hal_dma.c \
            stm32h5xx_hal_dma_ex.c \
            stm32h5xx_hal_dts.c \
            stm32h5xx_hal_exti.c \
            stm32h5xx_hal_flash.c \
            stm32h5xx_hal_flash_ex.c \
            stm32h5xx_hal_fmac.c \
            stm32h5xx_hal_gpio.c \
            stm32h5xx_hal_gtzc.c \
            stm32h5xx_hal_i2c.c \
            stm32h5xx_hal_i2c_ex.c \
            stm32h5xx_hal_i3c.c \
            stm32h5xx_hal_icache.c \
            stm32h5xx_hal_otfdec.c \
            stm32h5xx_hal_pcd.c \
            stm32h5xx_hal_pcd_ex.c \
            stm32h5xx_hal_pka.c \
            stm32h5xx_hal_pssi.c \
            stm32h5xx_hal_pwr.c \
            stm32h5xx_hal_pwr_ex.c \
            stm32h5xx_hal_ramcfg.c \
            stm32h5xx_hal_rcc.c \
            stm32h5xx_hal_rcc_ex.c \
            stm32h5xx_hal_rng_ex.c \
            stm32h5xx_hal_rtc_ex.c \
            stm32h5xx_hal_sd.c \
            stm32h5xx_hal_smbus_ex.c \
            stm32h5xx_hal_spi_ex.c \
            stm32h5xx_hal_tim.c \
            stm32h5xx_hal_tim_ex.c \
            stm32h5xx_hal_uart.c \
            stm32h5xx_hal_uart_ex.c \
            stm32h5xx_hal_xspi.c \
            stm32h5xx_ll_cordic.c \
            stm32h5xx_ll_crs.c \
            stm32h5xx_ll_dlyb.c \
            stm32h5xx_ll_dma.c \
            stm32h5xx_ll_fmac.c \
            stm32h5xx_ll_i3c.c \
            stm32h5xx_ll_icache.c \
            stm32h5xx_ll_pka.c \
            stm32h5xx_ll_sdmmc.c \
            stm32h5xx_ll_spi.c \
            stm32h5xx_ll_tim.c \
            stm32h5xx_ll_ucpd.c \
            stm32h5xx_ll_usb.c \
            stm32h5xx_util_i3c.c

#USB  ##TODO - need to work through the USB drivers, new directory: USBX
#USBCORE_DIR = $(ROOT)/lib/main/STM32H5/Middlewares/ST/usbx/Common
#USBCORE_SRC = $(notdir $(wildcard $(USBCORE_DIR)/Src/*.c))
#EXCLUDES    =
#USBCORE_SRC := $(filter-out ${EXCLUDES}, $(USBCORE_SRC))

#VPATH := $(VPATH):$(USBCDC_DIR)/Src:$(USBCORE_DIR)/Src:$(USBHID_DIR)/Src:$(USBMSC_DIR)/Src:$(STDPERIPH_DIR)/src

DEVICE_STDPERIPH_SRC := $(STDPERIPH_SRC) \
                        $(USBCORE_SRC) \
                        $(USBCDC_SRC) \
                        $(USBHID_SRC) \
                        $(USBMSC_SRC)

#CMSIS
VPATH           := $(VPATH):$(CMSIS_DIR)/Include:$(CMSIS_DIR)/Device/ST/STM32H5xx
VPATH           := $(VPATH):$(STDPERIPH_DIR)/Src
CMSIS_SRC       :=
INCLUDE_DIRS    := $(INCLUDE_DIRS) \
                   $(STDPERIPH_DIR)/Inc \
                   $(USBCORE_DIR)/Inc \
                   $(USBCDC_DIR)/Inc \
                   $(USBHID_DIR)/Inc \
                   $(USBMSC_DIR)/Inc \
                   $(CMSIS_DIR)/Core/Include \
                   $(ROOT)/lib/main/STM32H5/Drivers/CMSIS/Device/ST/STM32H5xx/Include \
                   $(ROOT)/src/main/drivers/stm32 \
                   $(ROOT)/src/main/drivers/stm32/vcp_hal

#Flags
ARCH_FLAGS      = -mthumb -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-sp-d16 -fsingle-precision-constant

# Flags that are used in the STM32 libraries
DEVICE_FLAGS    = -DUSE_HAL_DRIVER -DUSE_FULL_LL_DRIVER

#
# H563xx : 2M FLASH, 640KB SRAM
#
ifeq ($(TARGET_MCU),STM32H563xx)
DEVICE_FLAGS       += -DSTM32H563xx
DEFAULT_LD_SCRIPT   = $(LINKER_DIR)/stm32_flash_h563_2m.ld
STARTUP_SRC         = startup_stm32h563xx.s
MCU_FLASH_SIZE     := 2048
DEVICE_FLAGS       += -DMAX_MPU_REGIONS=16

# end H563xx


ifneq ($(DEBUG),GDB)
OPTIMISE_DEFAULT    := -Os
OPTIMISE_SPEED      := -Os
OPTIMISE_SIZE       := -Os

LTO_FLAGS           := $(OPTIMISATION_BASE) $(OPTIMISE_DEFAULT)
endif

else
$(error Unknown MCU for STM32H5 target)
endif

ifeq ($(LD_SCRIPT),)
LD_SCRIPT = $(DEFAULT_LD_SCRIPT)
endif

ifneq ($(FIRMWARE_SIZE),)
DEVICE_FLAGS   += -DFIRMWARE_SIZE=$(FIRMWARE_SIZE)
endif

DEVICE_FLAGS    += -DHSE_VALUE=$(HSE_VALUE) -DHSE_STARTUP_TIMEOUT=1000 -DSTM32

VCP_SRC =
#VCP_SRC = \
            drivers/stm32/vcp_hal/usbd_desc.c \
            drivers/stm32/vcp_hal/usbd_conf_stm32h5xx.c \
            drivers/stm32/vcp_hal/usbd_cdc_hid.c \
            drivers/stm32/vcp_hal/usbd_cdc_interface.c \
            drivers/stm32/serial_usb_vcp.c \
            drivers/usb_io.c

MCU_COMMON_SRC = \
            drivers/bus_i2c_timing.c \
            drivers/bus_quadspi.c \
            drivers/dshot_bitbang_decode.c \
            drivers/pwm_output_dshot_shared.c \
            drivers/stm32/bus_i2c_hal_init.c \
            drivers/stm32/bus_i2c_hal.c \
            drivers/stm32/bus_spi_ll.c \
            drivers/stm32/bus_quadspi_hal.c \
            drivers/stm32/debug.c \
            drivers/stm32/dma_reqmap_mcu.c \
            drivers/stm32/dshot_bitbang_ll.c \
            drivers/stm32/dshot_bitbang.c \
            drivers/stm32/exti.c \
            drivers/stm32/io_stm32.c \
            drivers/stm32/light_ws2811strip_hal.c \
            drivers/stm32/persistent.c \
            drivers/stm32/pwm_output.c \
            drivers/stm32/pwm_output_dshot_hal.c \
            drivers/stm32/rcc_stm32.c \
            drivers/stm32/serial_uart_hal.c \
            drivers/stm32/timer_hal.c \
            drivers/stm32/transponder_ir_io_hal.c \
            drivers/stm32/camera_control.c \
            drivers/stm32/system_stm32h5xx.c \
            startup/system_stm32h5xx.c

#            drivers/stm32/memprot_hal.c \
#            drivers/stm32/memprot_stm32h5xx.c \
#            drivers/stm32/serial_uart_stm32h5xx.c \
#            drivers/stm32/sdio_h5xx.c \
#            drivers/stm32/timer_stm32h5xx.c \
#            drivers/stm32/adc_stm32h5xx.c \
#            drivers/stm32/dma_stm32h5xx.c \

MCU_EXCLUDES = \
            drivers/bus_i2c.c

MSC_SRC =
#MSC_SRC = \
            drivers/stm32/usb_msc_hal.c \
            drivers/usb_msc_common.c \
            msc/usbd_storage.c \
            msc/usbd_storage_emfat.c \
            msc/emfat.c \
            msc/emfat_file.c \
            msc/usbd_storage_sd_spi.c \
            msc/usbd_storage_sdio.c

DSP_LIB := $(ROOT)/lib/main/CMSIS/DSP
DEVICE_FLAGS += -DARM_MATH_MATRIX_CHECK -DARM_MATH_ROUNDING -DUNALIGNED_SUPPORT_DISABLE -DARM_MATH_CM7
