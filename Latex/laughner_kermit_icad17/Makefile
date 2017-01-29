SAMPLES=laughner_kermit_icad17.pdf

all: $(SAMPLES)

clean: cleantmp
		rm -f *.pdf

cleantmp:
		rm -f *.aux
		rm -f *.bbl
		rm -f *.blg
		rm -f *.log
		rm -f *.out

%.pdf: %.tex # %.bib
		pdflatex "$<"
		bibtex `basename "$<" .tex`
		pdflatex "$<"
		pdflatex "$<"

.PHONY:all clean
