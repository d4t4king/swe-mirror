# SmoothWall Build system.
#
# (c) SmoothWall Ltd 2005
#
# This code is distributed under the terms of the GPL v2.

include ../../../Makefile.conf

PACKAGE = GD
VERSION = 2.53

#VERSION = 2.55		# broken
#VERSION = 2.56		# broken

BASE_URL = http://search.cpan.org/CPAN/authors/id/L/LD/LDS/

CONFIGURE = yes
CLEAN = yes

configure: $(DIR)/
	@+cd $(DIR); echo 'y' | perl Makefile.PL

clean:
	@echo -n " $(PACKAGE)"
	@rm -rf $(DIR)
	@rm -rf $(COMPILE_DIR)

include ../../../Makefile.rules
