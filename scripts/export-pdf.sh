#!/usr/bin/env bash
# Export des diapositives après chaque rendu Quarto, complet ou partiel.
set -euo pipefail

fail() {
  printf 'ERREUR PDF : %s\n' "$*" >&2
  exit 1
}

command -v decktape >/dev/null 2>&1 ||
  fail "DeckTape est introuvable. Vérifier : decktape --version"

# À défaut de navigateur système, DeckTape utilise son navigateur fourni.
chrome_args=()
chromium_bin="${CHROMIUM_BIN:-}"

if [[ -n "$chromium_bin" ]]; then
  chromium_bin="$(command -v "$chromium_bin")" ||
    fail "CHROMIUM_BIN est introuvable."
else
  for candidate in chromium chromium-browser google-chrome google-chrome-stable; do
    if chromium_bin="$(command -v "$candidate")"; then
      break
    fi
  done
fi

if [[ -n "$chromium_bin" ]]; then
  chrome_args=(--chrome-path "$chromium_bin")
  printf 'Navigateur PDF : %s\n' "$chromium_bin"
else
  echo 'Navigateur PDF : navigateur fourni avec DeckTape.'
fi

outputs="${QUARTO_PROJECT_OUTPUT_FILES:-}"

# Quarto peut transmettre la liste via un fichier lorsque ce mode est activé.
if [[ -n "${QUARTO_USE_FILE_FOR_PROJECT_OUTPUT_FILES:-}" ]]; then
  [[ -f "$outputs" ]] ||
    fail "Liste des sorties Quarto introuvable : $outputs"
  outputs="$(cat "$outputs")"
fi

[[ -n "$outputs" ]] ||
  fail "Liste des sorties vide. Lancer ce script via quarto render."

count=0
status=0
tmp_pdf=''

trap '[[ -z "$tmp_pdf" ]] || rm -f -- "$tmp_pdf"' EXIT

while IFS= read -r html || [[ -n "$html" ]]; do
  html="${html%$'\r'}"
  [[ "$html" == *.html ]] || continue
  [[ -f "$html" ]] || fail "Sortie HTML introuvable : $html"

  html_abs="$(realpath -- "$html")"
  pdf_abs="${html_abs%.html}.pdf"

  # Remplacer le précédent PDF uniquement après un export réussi.
  tmp_pdf="$(mktemp "${pdf_abs%.pdf}.tmp.XXXXXX.pdf")"

  printf 'Export PDF : %s\n' "$pdf_abs"

  if decktape reveal \
    "${chrome_args[@]}" \
    --chrome-arg=--allow-file-access-from-files \
    --size 960x540 \
    --pause 300 \
    --load-pause 1000 \
    "$html_abs" "$tmp_pdf"; then

    if [[ -s "$tmp_pdf" ]] &&
       [[ "$(head -c 5 "$tmp_pdf")" == '%PDF-' ]]; then
      mv -f -- "$tmp_pdf" "$pdf_abs"
      printf 'PDF créé : %s\n' "$pdf_abs"
      count=$((count + 1))
    else
      printf 'ERREUR PDF : fichier vide ou invalide pour %s\n' "$html" >&2
      status=1
    fi
  else
    printf 'ERREUR PDF : échec de DeckTape pour %s\n' "$html" >&2
    status=1
  fi

  rm -f -- "$tmp_pdf"
  tmp_pdf=''
done <<< "$outputs"

printf 'Export terminé : %s PDF créé(s).\n' "$count"
exit "$status"
