PREFIX = /etc/X11
CWD = $(shell pwd)
CONFS = $(notdir $(wildcard $(CWD)/xorg.conf.d/*.conf))
USERID = $(shell id -u)
HOME = "/home/m3cool"

install: isroot
	install --mode 0644 --owner=root --group=root $(CWD)/xorg.conf $(PREFIX)/xorg.conf
	@for conf in `echo $(CONFS)`; do\
		echo "Installing $(PREFIX)/$$conf...";\
		install --mode 0644 --owner=root --group=root $(CWD)/xorg.conf.d/$$conf $(PREFIX)/xorg.conf.d/$$conf;\
	done
	ln -s Xresources $(HOME)/.Xresources
	ln -s xinitrc $(HOME)/.xinitrc

isroot:
	@if [ $(USERID) -ne 0 ]; then\
		echo "Must be root!";\
		exit 1;\
	fi

uninstall: isroot
	rm -rf $(PREFIX)/xorg.conf
	@for conf in $(CONFS); do\
		echo "removing $$conf...";\
		rm -rf $(PREFIX)/xorg.conf.d/$$conf;\
	done
	unlink $(HOME)/.Xresources
	unlink $(HOME)/.xinitrc
