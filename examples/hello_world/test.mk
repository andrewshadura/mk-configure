DISTCLEANDIRS+=	${.CURDIR}/usr *.tar *.tar.gz *.tar.bz2

tartf_cleanup=	sed -e 's,^[.]/,,' -e 's,/$$,,' -e '/^[.]*$$/ d'

.PHONY : test_output
test_output:
	@set -e; \
	${.OBJDIR}/hello_world; \
	rm -rf ${.OBJDIR}${PREFIX}; \
	\
	echo =========== all ============; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"; \
	\
	echo ========= install ==========; \
	${MAKE} ${MAKEFLAGS} installdirs install DESTDIR=${.OBJDIR} \
		> /dev/null; \
	find ${.OBJDIR}${PREFIX} -type f -o -type d | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"; \
	\
	echo ======== uninstall =========; \
	${MAKE} ${MAKEFLAGS} uninstall DESTDIR=${.OBJDIR} > /dev/null; \
	find ${.OBJDIR}${PREFIX} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}";\
	\
	echo ========== clean ===========; \
	${MAKE} ${MAKEFLAGS} clean DESTDIR=${.OBJDIR} > /dev/null; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}";\
	\
	echo ======== bin_tar ===========; \
	${MAKE} ${MAKEFLAGS} bin_tar > /dev/null; \
	${TAR} -tf ${.CURDIR:T}.tar | ${tartf_cleanup}; \
	\
	echo ======== bin_targz ===========; \
	${MAKE} ${MAKEFLAGS} bin_targz > /dev/null; \
	${GZIP} -dc ${.CURDIR:T}.tar.gz | ${TAR} -tf - | ${tartf_cleanup}; \
	\
	echo ======== bin_tarbz2 ===========; \
	${MAKE} ${MAKEFLAGS} bin_tarbz2 > /dev/null; \
	${BZIP2} -dc ${.CURDIR:T}.tar.bz2 | ${TAR} -tf - | ${tartf_cleanup}; \
	\
	echo ======= distclean ==========; \
	${MAKE} ${MAKEFLAGS} distclean DESTDIR=${.OBJDIR} > /dev/null; \
	find ${.OBJDIR} -type f | \
	mkc_test_helper "${PREFIX}" "${.OBJDIR}"

.include <mkc.minitest.mk>
