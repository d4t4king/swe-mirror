# SmoothWall Build system.
#
# (c) SmoothWall Ltd 2005
#
# This code is distributed under the terms of the GPL v2.

include ../Makefile.conf

PACKAGE = setuids
VERSION = 0.0

PROGS = setdmzholes setportfw setoutbound setxtaccess restartdhcp restartsnort \
	restartsquid smoothiedeath smoothierebirth alcateladslfw \
	installpackage ipsecctrl restartdnsproxy restartssh \
	setadvnet setipblock restartupnp restartntpd updown

compile:
	@make -C $(COMPILE_DIR)

install: compile
	@(for PROG in $(PROGS); do \
		install -D $(COMPILE_DIR)/$$PROG $(PKG_ROOT)/usr/bin/setuids/$$PROG; \
	done;)
	install -D /bin/date $(PKG_ROOT)/usr/bin/setuids/date

all: install
	@mkdir -p $(PKG_ROOT)
	@tar -zcvf $(TARGET_DIR)/smoothwall-$(PACKAGE).tar.gz -C $(PKG_ROOT) .

clean:
	@echo -n " $(PACKAGE)"
	@make --no-print-directory -C $(COMPILE_DIR) clean >/dev/null 2>&1
ifeq ($(BUILD_PHASE), Final)
	@rm -rf $(PKG_ROOT)
	@rm -f $(TARGET_DIR)/smoothwall-$(PACKAGE).tar.gz
endif

download:
	@true

packageinfo.html: clean
	@echo "<li><span style='font-size:large;'>$(PACKAGE) $(VERSION)</span><br>" >>/tmp/packageinfo.html
	@tar --exclude */.svn -zcvf /tmp/downloads/$(TARBALL).tar.gz $(DIR) 
	@echo "Download: <a href='downloads/$(TARBALL).tar.gz'>$(TARBALL).tar.gz</a><br>" >>/tmp/packageinfo.html
