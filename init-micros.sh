#!/usr/bin/env bash
set -euo pipefail

echo "Init for Quarkus micro service with hexagonal architecture"
echo

read -rp "Name? (use project name possibly) : " MICROS_NAME
if [[ -z "${MICROS_NAME}" ]]; then
  echo "! The name must have a value"
  exit 1
fi

read -rp "Define groupId (es. org.acme) : " GROUP_ID
if [[ -z "${GROUP_ID}" ]]; then
  echo "! groupId is mandatory"
  exit 1
fi

DEFAULT_BASE_PACKAGE="${GROUP_ID}.$(echo "${MICROS_NAME}" | tr '-' '.')"
read -rp "Base package [${DEFAULT_BASE_PACKAGE}] (press enter) : " BASE_PACKAGE
BASE_PACKAGE="${BASE_PACKAGE:-$DEFAULT_BASE_PACKAGE}"


echo
echo "summary info:"
echo "  MICROS_NAME   =  ${MICROS_NAME}"
echo "  GROUP_ID      =  ${GROUP_ID}"
echo "  BASE_PACK     =  ${BASE_PACKAGE}"
echo

read -rp "Proceed? [y/N] :" CONFIRM
if [[ "${CONFIRM}" != "y" && "${CONFIRM}" != "Y" ]]; then
  echo "wrong digit"
  exit 0
fi

# START BONUS-STEP - sed cross-platform by chatGPT (idk if actually work)
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE=(sed -i '')
else
  SED_INPLACE=(sed -i)
fi

escape_sed() {
  # escape / e .
  printf '%s' "$1" | sed 's/[\/&]/\\&/g'
}

ESC_MICROS_NAME=$(escape_sed "${MICROS_NAME}")
ESC_GROUP_ID=$(escape_sed "${GROUP_ID}")
ESC_BASE_PACKAGE=$(escape_sed "${BASE_PACKAGE}")

echo "Replace placeholder..."
echo

# END BONUS STEP from chatGPT

FILES=$(find . \
  -type f \
  ! -path "*/.git/*" \
  ! -path "*/target/*" \
  ! -name "init-template.sh" \
  \( -name "*.java" -o \
     -name "*.xml" -o \
     -name "*.properties" -o \
     -name "*.yml" -o \
     -name "*.yaml" -o \
     -name "*.md" -o \
     -name "pom.xml" \))

if [[ -z "${FILES}" ]]; then
  echo "No files found to replace, please check script if work correctly"
else
  echo "__MICROS_TEMPLATE__ replacing"
  "${SED_INPLACE[@]}" "s/__MICROS_TEMPLATE__/${ESC_MICROS_NAME}/g" ${FILES}
  echo "__GROUP_ID__ replacing"
  "${SED_INPLACE[@]}" "s/__GROUP_ID__/${ESC_GROUP_ID}/g" ${FILES}
  echo "__BASE_PACKAGE__ replacing"
  "${SED_INPLACE[@]}" "s/__BASE_PACKAGE__/${ESC_BASE_PACKAGE}/g" ${FILES}
fi

echo
echo "Renaming module directory"

rename_if_exists() {
  local OLD="$1"
  local NEW="$2"
  if [[ -d "${OLD}" ]]; then
    mv "${OLD}" "${NEW}"
    echo " ${OLD} -> ${NEW} "
  fi
}

rename_if_exists "__MICROS_TEMPLATE__-domain" "${MICROS_NAME}-domain"
rename_if_exists "__MICROS_TEMPLATE__-application" "${MICROS_NAME}-application"
rename_if_exists "__MICROS_TEMPLATE__-inbound-adapter" "${MICROS_NAME}-inbound-adapter"
rename_if_exists "__MICROS_TEMPLATE__-outbound-adapter" "${MICROS_NAME}-outbound-adapter"
rename_if_exists "__MICROS_TEMPLATE__-boot" "${MICROS_NAME}-boot"

echo 
echo "Rename directory base package Java"

DIR_PATH="${BASE_PACKAGE//./\/}"

while IFS= read -r DIR; do
  PARENT_DIR="$(dirname "$DIR")"
  TARGET_DIR="${PARENT_DIR}/${DIR_PATH}"

  mkdir -p "${PARENT_DIR}"
  mkdir -p "$(dirname "${TARGET_DIR}")"

  mv "$DIR" "$TARGET_DIR"
  echo " ${DIR} -> ${TARGET_DIR}"
done < <(find . -type d -name "__BASE_PACKAGE__")

echo
echo "New micro service initialized"

echo "Next step:"
echo " - Rename root directory with '__MICROS_TEMPLATE__' in '${MICROS_NAME}' "
echo " - Run: ./mvnw clean install from terminal "
echo " - Run: quarkus:dev from ${MICROS_NAME}-boot:"
echo "        cd ${MICROS_NAME}-boot"
echo "        ../mvnw quarkus:dev"
echo
echo " - Start programming your fresh new micro service with hexagonal architecture"
