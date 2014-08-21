EXCL_RE='zzzz'

.PHONY : test_output
test_output:
	@ \
	${.OBJDIR}/hello_autoconf; \
	rm -rf ${.OBJDIR}${PREFIX}; \
	\
	echo =========== all ============; \
	find ${.OBJDIR} -type f | grep -Ev '${EXCL_RE}' | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"; \
	\
	echo ========== clean ===========; \
	${MAKE} ${MAKEFLAGS} clean > /dev/null; \
	find ${.OBJDIR} -type f | grep -vE '${EXCL_RE}' | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"; \
	\
	echo ========== all SHRTOUT=yes ===========; \
	${MAKE} ${MAKEFLAGS} all SHRTOUT=yes | \
	grep -E '^[[:alpha:]]+:'; \
	\
	echo ======= cleandir ==========; \
	${MAKE} ${MAKEFLAGS} cleandir > /dev/null; \
	find ${.OBJDIR} -type f | grep -vE '${EXCL_RE}' | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"

.include <mkc.minitest.mk>
