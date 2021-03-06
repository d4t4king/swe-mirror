# SmoothWall Build system.
#
# (c) SmoothWall Ltd 2005
#
# This code is distributed under the terms of the GPL v2.

include ../Makefile.conf
include ../Makefile.versions

PACKAGE = binutils
VERSION = 2.22

BASE_URL = http://ftp.gnu.org/gnu/binutils
TARBALL = $(PACKAGE)-$(VERSION)
EXTENSION = .tar.bz2

BASE_GMP = ftp://ftp.gnu.org/gnu/gmp
TAR_GMP = gmp-$(GMP_VER).tar.bz2

BASE_MPFR = http://www.mpfr.org/mpfr-current
TAR_MPFR = mpfr-$(MPFR_VER).tar.bz2

COMPILE_DIR = $(DIR)-compile

PATCH_FILE1 = binutils-2.22-build_fix-1.patch

ifeq ($(BITS_64), yes)
	BITS = 64
endif

# Tool Chain Build Stage_1
#
ifeq ($(BUILD_PHASE), Stage_1)

CONFIG_OPTS = \
	      --target=$(SWE_TGT)        \
	      --prefix=$(TOOLS_DIR)      \
	      --with-sysroot=$(ROOT)     \
	      --with-lib-path=$(TOOLS_DIR)/lib \
	      --disable-nls              \
	      --disable-werror

COMPILE = yes
compile: configure
	$(MAKE) $(JOBS) -C $(COMPILE_DIR)

INSTALL = yes
install: compile
ifeq ($(BITS_64), yes)
	mkdir -pv $(TOOLS_DIR)/lib
	ln -sv lib $(TOOLS_DIR)/lib64
endif
	$(MAKE) -C $(COMPILE_DIR) install
endif # Stage 1


# Tool Chain Build Stage_2
#
ifeq ($(BUILD_PHASE), Stage_2)

PRE_CONFIGURE = CC=$(SWE_TGT)-gcc \
	        AR=$(SWE_TGT)-ar RANLIB=$(SWE_TGT)-ranlib

CONFIG_OPTS = \
	      --host=$(FINAL_TGT) \
	      --build=$(FINAL_TGT) \
	      --target=$(FINAL_TGT) \
	      --prefix=$(TOOLS_DIR) \
	      --disable-nls \
	      --with-sysroot     \
	      --with-lib-path=$(TOOLS_DIR)/lib

COMPILE = yes
compile: configure
	$(MAKE) $(JOBS) -C $(COMPILE_DIR)

INSTALL = yes
install: compile
	$(MAKE) -C $(COMPILE_DIR) install
	
	@ # Get ready for second adjusting
	$(MAKE) -C $(COMPILE_DIR)/ld clean
	$(MAKE) $(JOBS) -C $(COMPILE_DIR)/ld LIB_PATH=/usr/lib:/lib
	cp -v  $(COMPILE_DIR)/ld/ld-new $(TOOLS_DIR)/bin
endif # Stage 2


# Final Build Stage
#
ifeq ($(BUILD_PHASE), Final)

CONFIG_OPTS = \
	      --host=$(FINAL_TGT) \
	      --build=$(FINAL_TGT) \
	      --target=$(FINAL_TGT) \
	      --prefix=$(PKG_DIR) --enable-shared

DOWNLOAD = yes
download:
	@$(DL_CMD) $(BASE_GMP)/$(TAR_GMP)
	@$(DL_CMD) $(BASE_MPFR)/$(TAR_MPFR)
	@$(DL_CMD) $(BASE_URL)/$(TARBALL)$(EXTENSION) $(MD5)

PATCH = yes
patch: $(DIR)/
	cd $(DIR); tar -xvf ../../../downloads/$(TAR_GMP); mv gmp-$(GMP_VER) gmp
	cd $(DIR); tar -xvf ../../../downloads/$(TAR_MPFR); mv mpfr-$(MPFR_VER) mpfr
	rm -fv $(DIR)/etc/standards.info
	sed -i.bak '/^INFO/s/standards.info //' $(DIR)/etc/Makefile.in
	cd $(DIR); cat binutils-2.22-build_fix-1.patch | patch -p1 || exit 14


COMPILE = yes
compile: configure
	@make ${JOBS} -C $(COMPILE_DIR) tooldir=$(PKG_DIR)
	
INSTALL = yes
install: compile
	@mkdir -p $(PKG_ROOT)$(PKG_DIR)/include
	@make ${JOBS} -C $(COMPILE_DIR) DESTDIR=$(PKG_ROOT) tooldir=$(PKG_DIR) install
	@cp -v $(DIR)/include/libiberty.h $(PKG_ROOT)$(PKG_DIR)/include

adjust:
	# Return specs file to 'au natural'
	GCC_LIBNAM=`gcc -print-libgcc-file-name`; \
	  GCC_LIBNAMDIR=`dirname $${GCC_LIBNAM}`; \
	  rm -fv $${GCC_LIBNAMDIR}/specs

	make -C $(COMPILE_DIR)/ld INSTALL=$(PKG_ROOT)$(PKG_DIR)/bin/install install
endif # Final

include ../Makefile.rules
