MAKEFILEDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

notarget:
	cd "$(MAKEFILEDIR)/bundle" && $(MAKE) $(MAKECMDGOALS)

.DEFAULT:
	cd "$(MAKEFILEDIR)/bundle" && $(MAKE) $(MAKECMDGOALS)
