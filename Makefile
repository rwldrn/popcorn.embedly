BUILD_DIR = build

PREFIX = .
DIST_DIR = ${PREFIX}/dist

JS_ENGINE ?= `which node nodejs`
COMPILER = ${JS_ENGINE} ${BUILD_DIR}/uglify.js --unsafe
POST_COMPILER = ${JS_ENGINE} ${BUILD_DIR}/post-compile.js

SRC=popcorn.embedly.js



DIST = ${DIST_DIR}/popcorn.embedly.js
DIST_MIN = ${DIST_DIR}/popcorn.embedly.min.js

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}

all: project min hint
	@@echo "Project build complete."

project: ${DIST}

${DIST}: ${SRC} | ${DIST_DIR}
	@@echo "Building" ${DIST}
	@@cat ${SRC} > ${DIST};


min: project ${DIST_MIN}

${DIST_MIN}: ${DIST}
	@@if test ! -z ${JS_ENGINE}; then \
		echo "Minifying Project" ${DIST_MIN}; \
		${COMPILER} ${DIST} > ${DIST_MIN}.tmp; \
		${POST_COMPILER} ${DIST_MIN}.tmp > ${DIST_MIN}; \
		rm -f ${DIST_MIN}.tmp; \
	else \
		echo "You must have NodeJS installed in order to minify Project."; \
	fi


hint:
	@@if test ! -z ${JS_ENGINE}; then \
		echo "Hinting Project"; \
		${JS_ENGINE} build/jshint-check.js; \
	else \
		echo "Nodejs is missing"; \
	fi


clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}


.PHONY: all project hint min
