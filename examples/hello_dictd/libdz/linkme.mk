PATH.dz :=	${.PARSEDIR}

CPPFLAGS  +=	-I${PATH.dz}
DPLIBDIRS +=	${PATH.dz}
LDADD0    +=	-ldz
