PREFIX = /etc/X11
CWD = $(shell pwd)
CONFS = $(notdir $(wildcard $(CWD)/xorg.conf.d/*.conf))
USERID = $(shell id -u)
HOME = "/home/m3cool"

install: isroot
	-ln -s $(CWD)/xorg.conf $(PREFIX)/xorg.conf
	@for conf in `echo $(CONFS)`; do\
		echo "ln -s  $(CWD)/xorg.conf.d/$$conf $(PREFIX)/xorg.conf.d/$$conf...";\
		ln -s $(CWD)/xorg.conf.d/$$conf $(PREFIX)/xorg.conf.d/$$conf;\
	done

	-ln -s $(CWD)/Xresources $(HOME)/.Xresources
	-ln -s $(CWD)/xinitrc $(HOME)/.xinitrc

isroot:
	@if [ $(USERID) -ne 0 ]; then\
		echo "Must be root!";\
		exit 1;\
	fi

uninstall: isroot
	-unlink $(PREFIX)/xorg.conf
	@for conf in $(CONFS); do\
		echo "unlink $(PREFIX)/xorg.conf.d/$$conf...";\
		unlink $(PREFIX)/xorg.conf.d/$$conf;\
	done

	-unlink $(HOME)/.Xresources
	-unlink $(HOME)/.xinitrc
