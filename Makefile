TEX := master_resume_cjnowacek.tex
BASE := master_resume_cjnowacek
IT_OUT := exports/CJ-Nowacek-Pipeline-Resume.pdf
TA_OUT := exports/CJ-Nowacek-TechArt-Resume.pdf
CV_TEX := cv_teaching_cjnowacek.tex
CV_BASE := cv_teaching_cjnowacek
CV_OUT := exports/CJ-Nowacek-Rigging-Instructor-CV.pdf

LATEXMK := latexmk -pdf -interaction=nonstopmode -halt-on-error

# Cross-platform "open" command detection
UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
    OPEN_CMD := open
else ifeq ($(UNAME),Linux)
    OPEN_CMD := xdg-open
else
    # Windows (Git Bash, WSL, etc.)
    OPEN_CMD := start
endif

.PHONY: it techart cv clean realclean open-it open-techart open-cv help

# Default target shows help
help:
	@echo "Available targets:"
	@echo "  make it          - Build IT/DevOps resume"
	@echo "  make techart     - Build Technical Artist resume"
	@echo "  make cv          - Build rigging-instructor teaching CV"
	@echo "  make open-it     - Build and open IT resume"
	@echo "  make open-techart- Build and open TechArt resume"
	@echo "  make clean       - Remove temp files (keep PDFs)"
	@echo "  make realclean   - Remove all generated files"

it:
	@printf "\\ITtrue\n\\TechArtfalse\n" > profile_toggle.tex
	@echo "Building IT resume..."
	@mkdir -p exports
	@$(LATEXMK) $(TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(BASE).pdf $(IT_OUT)
	@echo "✓ Successfully built $(IT_OUT)"
	@latexmk -c

techart:
	@printf "\\ITfalse\n\\TechArttrue\n" > profile_toggle.tex
	@echo "Building TechArt resume..."
	@mkdir -p exports
	@$(LATEXMK) $(TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(BASE).pdf $(TA_OUT)
	@echo "✓ Successfully built $(TA_OUT)"
	@latexmk -c

cv:
	@echo "Building teaching CV..."
	@mkdir -p exports
	@$(LATEXMK) $(CV_TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(CV_BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(CV_BASE).pdf $(CV_OUT)
	@echo "✓ Successfully built $(CV_OUT)"
	@latexmk -c $(CV_TEX)

open-it: it
	@${OPEN_CMD} $(IT_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(IT_OUT)"

open-techart: techart
	@${OPEN_CMD} $(TA_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(TA_OUT)"

open-cv: cv
	@${OPEN_CMD} $(CV_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(CV_OUT)"

clean:
	@latexmk -c
	@rm -f profile_toggle.tex
	@echo "✓ Cleaned temporary files"

realclean:
	@latexmk -C
	@rm -f profile_toggle.tex $(IT_OUT) $(TA_OUT) $(CV_OUT)
	@echo "✓ Removed all generated files"
