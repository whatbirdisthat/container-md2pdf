NAM=md2pdf
BUILD_NAM=md2pdf-build
APT_PROXY=${APT_CACHER_PROXY}


#docker run -it --rm --entrypoint /usr/bin/pandoc \

define RUN_COMMAND
#!/usr/bin/env bash

INPUTFILE=$$1
AUTOGEN_OUTPUTFILE=$$(echo $$1 | sed 's/md$$/pdf/')
OUTPUTFILE=$${2:-$$AUTOGEN_OUTPUTFILE}

docker run -it --rm \
	-v $${PWD}:$${PWD} -w $${PWD} tqxr/$(NAM) $${INPUTFILE} -o $${OUTPUTFILE}

endef

export RUN_COMMAND

create-command:
	@echo "$$RUN_COMMAND" > "./${NAM}"
	@chmod uo+x "./${NAM}"

install:
	cp ./$(NAM) /usr/local/bin/$(NAM)

uninstall:
	if [ -f /usr/local/bin/$(NAM) ] ; then rm /usr/local/bin/$(NAM) ; fi

build: create-command
	if [ "$(APT_PROXY)" = "" ] ; then \
	docker build -t tqxr/$(BUILD_NAM) . ; \
	else \
	docker build --build-arg APT_CACHER_PROXY='$(APT_PROXY)' \
	-t tqxr/$(BUILD_NAM) . ; \
	fi
	cat $(NAM)-scratch.Dockerfile | docker build -t tqxr/$(NAM) -

clean:
	@if [ -f README.pdf ] ; then \
		rm README.pdf ; \
	fi
	@C=`docker images --filter=reference=tqxr/$(BUILD_NAM) | wc -l` ; \
	if [ $$C = 2 ] ; then \
	docker rmi tqxr/$(BUILD_NAM) ; \
	fi
	@C=`docker images --filter=reference=tqxr/$(NAM) | wc -l` ; \
	if [ $$C = 2 ] ; then \
	docker rmi tqxr/$(NAM) ; \
	fi
	@if [ -f ./$(NAM) ] ; then rm ./$(NAM) ; fi

fake:
	@if [ ! -f arch-bash.tgz ] ; then \
		docker image save tqxr/arch-bash > arch-bash.tgz ; \
	fi
	@docker image import arch-bash.tgz tqxr/$(NAM):latest


run:
	@EXIST=`docker images --filter=reference=tqxr/$(NAM) | wc -l` ; \
	if [ $$EXIST = 2 ] ; then \
	echo "EXIST = 2" ; \
	echo 'docker run -it --rm -v $${PWD}:$${PWD} -w $${PWD} tqxr/$(NAM)' ; \
	else \
	echo "CANNOT RUN $(NAM) - please 'make build' :)" ; \
	fi

define HELP_TEXT
md2pdf
------

A helper container for generating PDF files from Markdown source.

BUILDING & INSTALLING:
make build
sudo make install

# remove:
sudo make uninstall
make clean

Usage:

md2pdf <INPUT_FILENAME> [OUTPUT_FILENAME]

INPUT_FILENAME: the Markdown file to convert to PDF
OUTPUT_FILENAME: (optional) a filename to use for the result PDF

If OUTPUT_FILENAME is omitted, md2pdf will create a file
with the `.pdf` extension replacing the `.md` extension.

Example:

md2pdf README.md

Will create a file called `README.pdf` that is the result PDF.

BUGS:
The container is WAY too big.
I may or may not make it smaller, but if you want to,
I'll be happy to merge in a PR from someone who has.

endef
export HELP_TEXT

help:
		@:
		$(info $(HELP_TEXT))
