init:
	perl -MCPAN -e shell

build:
	mkdir -p ~/yqbin
	cp yq-bin_checker.pl ~/yqbin/yq-bin_checker.pl
	chmod +x ~/yqbin/yq-bin_checker.pl
	cp yq-bin_checker.sh ~/yqbin/yq-bin_checker.sh
	chmod +x ~/yqbin/yq-bin_checker.sh
