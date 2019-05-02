# md2pdf
---

## Generate PDF from Markdown

This container uses the highly awesome `pandoc`
to convert Markdown into PDF.

In order to make this happen a *truckload* of extra
stuff needs to be installed on the system.

:facepalm:

If you're into installing stuff on your
host machine (and you're using ubuntu/etc)

```bash
apt install -y \
  pandoc \
  texlive-latex-recommended texlive-latex-extra \
  mupdf mupdf-tools
```

This turns your system into a fully fledged X windows machine
which is *nuts*. This is a ~~docker~~ container waiting to happen.

```bash
pandoc README.md -o README.pdf
mupdf README.pdf &
```

The above script is essentially what the container
does. This means we can not install all this stuff
and "pollute" our system with a bunch of stuff
that (sometimes) won't come out again -
ever had that weird feeling when `apt` tells you 
it will install 300mb of files but when you
`apt uninstall` it says "100k of space will be freed"
and it's like ... "wha?"

This is why `CONTAINER`.

* Rendering from markdown to PDF
* Doing some fancy things with pandoc

> Note: Columns and things are weird

---

This is a test Markdown file, for use
in the generation of a pdf.

> Quoted text, as shown in a generated PDF.

---

# Why is the container so big?

~~Because I haven't ensmallinated it yet.~~
Ok so it has been ensmallinated, but it still comes in
at a _whopping_ *335MB* !!
This is because I have included *all* of the texlive stuff
from the good folks at *Ubuntu, Debian etc* who have spent
a bunch of time collecting all the goodies and producing
a package that has bucketloads of functionality.

My original goal was "make the smallest container" but
looking into it, I also want a pandoc/latex setup that
can do a lot of things (which I may or may not ever need).

Anyway blame Luke Smith, he's the one always going on about
how much awesome you can pack onto your latex install.

What this project _does_ do is containerise the stuff,
which is a really good start. You don't need any of
it on the base system any more. And it's really easy to remove.

> (unless you want to _view_ the PDF - then you'll
> need something like `mupdf` etc)

# Oh and why not include mupdf and then bind-mount the DISPLAY ?
> *Read Jess Frazelle's blog and you can have the power!!*


# When will it be finished?

Hopefully soon. Realistically, these things are never "finished".

`:)`

# Can I give feedback about this project?

Sure. Pull Requests welcome and all that - this is all just code.

---
