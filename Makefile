RUBY_DIRS := 2.4 2.3 2.2 2.1
ONBUILD_DIRS := 2.4/onbuild 2.3/onbuild 2.2/onbuild 2.1/onbuild

.PHONY: all clean $(RUBY_DIRS) $(ONBUILD_DIRS)

all: $(RUBY_DIRS) $(ONBUILD_DIRS)

clean: $(ONBUILD_DIRS) $(RUBY_DIRS)

$(RUBY_DIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

$(ONBUILD_DIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)
