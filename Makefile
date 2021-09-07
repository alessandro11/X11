PREFIX := /etc/X11
PREFIX_XRESOURCES := "${HOME}"
CWD := $(shell pwd)
CONFS := $(notdir $(wildcard $(CWD)/xorg.conf.d/*.conf))
USERID := $(shell id -u)
GROUPID := $(shell id -g)

.PHONY: xresources
xresources:
	-cp -a Xresources.d $(PREFIX_XRESOURCES)/.Xresources.d

.PHONY: install
install: isroot
	-ln -s $(CWD)/xorg.conf $(PREFIX)/xorg.conf
	@for conf in `echo $(CONFS)`; do\
		echo "ln -s  $(CWD)/xorg.conf.d/$$conf $(PREFIX)/xorg.conf.d/$$conf...";\
		ln -s $(CWD)/xorg.conf.d/$$conf $(PREFIX)/xorg.conf.d/$$conf;\
	done

	-ln -s $(CWD)/Xresources $(HOME)/.Xresources
	-ln -s $(CWD)/xinitrc $(HOME)/.xinitrc

.PHONY: isroot
isroot:
	@if [ $(USERID) -ne 0 ]; then\
		echo "Must be root!" 1>&2;\
		exit 1;\
	fi

.PHONY: uninstall
uninstall: isroot
	-unlink $(PREFIX)/xorg.conf
	@for conf in $(CONFS); do\
		echo "unlink $(PREFIX)/xorg.conf.d/$$conf...";\
		unlink $(PREFIX)/xorg.conf.d/$$conf;\
	done

	-unlink $(HOME)/.Xresources
	-unlink $(HOME)/.xinitrc
