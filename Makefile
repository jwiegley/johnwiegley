all: upload

upload: site
	lftp -u johnw@newartisans.com,$(shell pass ftp.fastmail.com | head -1) \
	    ftp://johnw@newartisans.com@ftp.fastmail.com \
	    -e "set ftp:ssl-allow no; mirror --reverse $(PWD)/_site /johnw.newartisans.com/files/johnwiegley ; quit"

site:
	sitebuilder rebuild
