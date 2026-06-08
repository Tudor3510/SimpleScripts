#!/bin/bash

# Usage:
#   ./printUSB.sh file.pdf
#   ./printUSB.sh file.pdf 1-4,5,7
#   ./printUSB.sh file.pdf odd
#   ./printUSB.sh file.pdf even

GS="/mnt/c/Program Files (x86)/gs/gs10.05.1/bin/gswin32c.exe"
PRINTER="HP LaserJet Professional P1102"

PDF="$1"
PAGE_SPEC="${2:-}"

if [ -z "$PDF" ]; then
    echo "Usage: $0 <pdf-file> [pages|odd|even]"
    exit 1
fi

if [ ! -f "$PDF" ]; then
    echo "Error: File not found: $PDF"
    exit 1
fi

PAGE_LIST=""

case "$PAGE_SPEC" in
    odd|even)
        TOTAL_PAGES=$(
            "$GS" \
                -dNODISPLAY \
                -dNOSAFER \
                -c "($PDF) (r) file runpdfbegin pdfpagecount = quit" \
            | tail -n 1
        )

        if ! [[ "$TOTAL_PAGES" =~ ^[0-9]+$ ]]; then
            echo "Error: Could not determine PDF page count."
            exit 1
        fi

        if [ "$PAGE_SPEC" = "odd" ]; then
            PAGE_LIST=$(seq 1 2 "$TOTAL_PAGES" | paste -sd, -)
        else
            PAGE_LIST=$(seq 2 2 "$TOTAL_PAGES" | paste -sd, -)
        fi
        ;;
    "")
        # Print entire PDF
        ;;
    *)
        # Remove spaces so both "1-4,5,7" and "1-4, 5, 7" work
        PAGE_LIST="${PAGE_SPEC// /}"
        ;;
esac

CMD=(
    "$GS"
    -dBATCH
    -dNOPAUSE
    -dNoCancel
    -sDEVICE=mswinpr2
    -sPAPERSIZE=a4
    "-sOutputFile=%printer%$PRINTER"
)

if [ -n "$PAGE_LIST" ]; then
    CMD+=("-sPageList=$PAGE_LIST")
fi

CMD+=("$PDF")

"${CMD[@]}"