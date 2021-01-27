PREFIX = /etc/X11
CWD = $(shell pwd)
CONFS = $(notdir $(wildcard $(CWD)/xorg.conf.d/*.conf))
USERID = $(shell id -u)

# install: isroot
# 	-ln -s $(CWD)/xorg.conf $(PREFIX)/xorg.conf
# 	@for conf in `echo $(CONFS)`; do\
# 		echo "ln -s  $(CWD)/xorg.conf.d/$$conf $(PREFIX)/xorg.conf.d/$$conf...";\
# 		ln -s $(CWD)/xorg.conf.d/$$conf $(PREFIX)/xorg.conf.d/$$conf;\
# 	done

# 	-ln -s $(CWD)/Xresources $(HOME)/.Xresources
# 	-ln -s $(CWD)/xresources-themes $(HOME)/.xresources-themes
# 	-ln -s $(CWD)/xinitrc $(HOME)/.xinitrc
# 	-ln -s $(CWD)/xinitrc-helpers.sh $(HOME)/.xinitrc-helpers.sh

install:
	install $(CWD)/Xresources $(HOME)/.Xresources
	install $(CWD)/xresources-themes $(HOME)/.xresources-themes
	install $(CWD)/xinitrc $(HOME)/.xinitrc
	install $(CWD)/xinitrc-helpers.sh $(HOME)/.xinitrc-helpers.sh

deps:
	xorg-xrdb xcompmgr xbindkeys numlockx xorg-xrandr setkb.sh

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
	-unlink $(HOME)/.xinitrc-helpers.sh
	-unlink $(HOME)/.xresources-themes

