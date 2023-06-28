#!/bin/bash
BUILD_DIR=_build
INSTALL_DIR=run
TEST_DIR=test/

function help()
{
  echo "./cleanCMake.sh [options]"
  echo "  -c          Basic cmake clean functionality [cmake --build ${BUILD_DIR} -j 1 --target clean]"
  echo "  -i          Remove cmake binary installs [xargs rm < ${BUILD_DIR}/install_manifest.txt]"
  # echo "  -l          Remove symlinks (WPS) [ find ${TEST_DIR} -type l -exec rm {} \; ]"
  echo "  -f          Remove build & install folders (WPS) [ rm ${BUILD_DIR} -r; rm ${INSTALL_DIR}/ -r ]"
  echo "  -a          Remove all (WPS), equivalent to -f (more specifically -c -i -f)"
}

CLEAN_BASIC_BUILD=FALSE
CLEAN_BASIC_INSTALL=FALSE
CLEAN_LINKS=FALSE
CLEAN_FOLDERS=FALSE
CLEAN_ALL=FALSE

while getopts "hcilfa" opt; do
  case ${opt} in
    c)
      CLEAN_BASIC_BUILD=TRUE
    ;;
    i)
      CLEAN_BASIC_INSTALL=TRUE
    ;;
    l)
      CLEAN_LINKS=TRUE
    ;;
    f)
      CLEAN_FOLDERS=TRUE
    ;;
    a)
      CLEAN_ALL=TRUE
    ;;
    h)  help; exit 0 ;;
    *)  help; exit 1 ;;
    :)  help; exit 1 ;;
    \?) help; exit 1 ;;
  esac
done

if [[ $OPTIND -eq 1 ]]; then
  # Do basic clean I guess
  CLEAN_BASIC_BUILD=TRUE
fi

if [[ "${CLEAN_BASIC_BUILD}" == "TRUE" || "${CLEAN_ALL}" == "TRUE" ]]; then
  echo "Doing cmake make clean"
  cmake --build ${BUILD_DIR} -j 1 --target clean
fi

if [[ "${CLEAN_BASIC_INSTALL}" == "TRUE" || "${CLEAN_ALL}" == "TRUE" ]]; then
  echo "Removing binary installs"
  xargs rm < ${BUILD_DIR}/install_manifest.txt
fi

# if [[ "${CLEAN_LINKS}" == "TRUE" || "${CLEAN_ALL}" == "TRUE" ]]; then
#   echo "Removing all symlinks in ${TEST_DIR}"
#   find ${TEST_DIR} -type l -exec rm {} \;
# fi

if [[ "${CLEAN_FOLDERS}" == "TRUE" || "${CLEAN_ALL}" == "TRUE" ]]; then
  echo "Deleting ${BUILD_DIR} & ${INSTALL_DIR}/"
  rm ${BUILD_DIR} -r; rm ${INSTALL_DIR}/ -r
fi