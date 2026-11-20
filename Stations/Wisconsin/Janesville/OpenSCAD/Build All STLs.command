#!/bin/bash
# =====================================================================
#  CMSP Janesville WI Station - build every STL for both printers
#  Double-click this file in Finder (first time: right-click > Open).
#  Writes to  ../STL/Bambu P1S/<part>/  and  ../STL/Large Format/<part>/
#  Old STLs with the same names are replaced.
# =====================================================================
cd "$(dirname "$0")"
MASTER="Janesville_Station.scad"
STL_ROOT="../STL"

# find OpenSCAD
for c in "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" \
         "/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD" \
         "$(command -v openscad)"; do
  [ -x "$c" ] && OPENSCAD="$c" && break
done
if [ -z "$OPENSCAD" ]; then
  echo "Could not find OpenSCAD. Install it in /Applications and try again."; read -p "Press Return to close"; exit 1
fi
echo "Using $OPENSCAD"

TMP="$(mktemp -d)"
for PRINTER in P1S GIGA; do
  [ "$PRINTER" = "GIGA" ] && FOLDER="Large Format" || FOLDER="Bambu P1S"
  # ask the master file for the parts list and section counts for this printer
  "$OPENSCAD" -o "$TMP/list.csg" -D "PRINTER=\"$PRINTER\"" -D "LIST=true" "$MASTER" 2>&1 \
    | grep 'PART|' | sed 's/.*PART|//; s/"$//' > "$TMP/parts.txt"
  while IFS='|' read -r NAME COUNT; do
    [ -z "$NAME" ] && continue
    GROUP="${NAME%%_*}"                     # e.g. Foundation_main -> Foundation
    OUT="$STL_ROOT/$FOLDER/$GROUP"; mkdir -p "$OUT"
    for ((T=0; T<COUNT; T++)); do
      FILE="$OUT/${NAME}_${PRINTER}_part$(printf %02d $((T+1))).stl"
      echo "[$PRINTER] $NAME section $((T+1)) of $COUNT"
      "$OPENSCAD" -o "$FILE" -D "PRINTER=\"$PRINTER\"" -D "SHOW=\"$NAME\"" -D "TILE=$T" "$MASTER" > "$TMP/log.txt" 2>&1 \
        || { echo "   FAILED - see message below"; tail -5 "$TMP/log.txt"; }
    done
  done < "$TMP/parts.txt"
done
rm -rf "$TMP"
echo; echo "Done. STLs are in the STL folder."
read -p "Press Return to close"
