all: build publish

build:
	nix build -f .

publish:
	rclone sync -v						\
	    ./result/share/html/johnwiegley			\
	    fastmail:/johnw.johnwiegley.com/files/johnwiegley

clean:
	rm -f result
