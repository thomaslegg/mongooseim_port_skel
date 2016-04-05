# Created by: tjlegg@the-eleven.com
# $FreeBSD: head/local/mongooseim/Makefile 

PORTNAME=	MongooseIM
PORTVERSION=	1.6.2
CATEGORIES=	net-im
MASTER_SITES=	https://github.com/esl/${PORTNAME}/archive/${PORTVERSION}/
DISTNAME=	${PORTNAME}-${PORTVERSION}

MAINTAINER=	tjlegg@gmail.com
COMMENT=	MongooseIM is an XMPP server focusing on performance and scalability

LICENSE=	GPLv2

BUILD_DEPENDS=	erl:${PORTSDIR}/lang/erlang 
LIB_DEPENDS=	libexpat.so:${PORTSDIR}/textproc/expat2
RUN_DEPENDS=	erl:${PORTSDIR}/lang/erlang-runtime18 


USES=		gmake #shebangfix
#SHEBANG_FILES=	rel/files/erl \
#	rel/files/mongooseim \
#	tools/compile_riak_pb.sh

#USE_RC_SUBR=	riak
CPPFLAGS+=      -I${LOCALBASE}/include
LIBS+=          -L${LOCALBASE}/lib


PLIST=		${WRKDIR}/pkg-plist
PLIST_SUB+=	MONGOOSEIM_CONFDIR=${MONGOOSEIM_CONFDIR} \
		MONGOOSEIM_DBDIR=${MONGOOSEIM_DBDIR} \
		MONGOOSEIM_HOMEDIR=${MONGOOSEIM_HOMEDIR} \
		MONGOOSEIM_LIBDIR=${MONGOOSEIM_LIBDIR} \
		MONGOOSEIM_LOGDIR=${MONGOOSEIMG_LOGDIR}

USERS=		rabbitmq
GROUPS=		rabbitmq

MONGOOSEIM_CONFDIR?=	/usr/local/etc/mongooseim
MONGOOSEIM_LOGDIR?=	/var/log/mongooseim
MONGOOSEIM_DBDIR?=	/var/db/mongooseim
MONGOOSEIM_LIBDIR?=	/usr/local/lib/mongooseim/lib
MONGOOSEIM_HOMEDIR?=	/usr/local/lib/mongooseim

ALL_TARGET=	rel
MAKE_JOBS_UNSAFE=yes
MAKE_ENV=	PATH=${LOCALBASE}/lib/erlang/bin:${PATH}


.include <bsd.port.options.mk>

post-patch:
#	@${REINPLACE_CMD} 's|%%PREFIX%%|${PREFIX}|g' ${WRKSRC}/rel/vars.config

pre-install:
	${RM} -f ${PLIST}
	${CAT} ${PKGDIR}/pkg-plist >> ${PLIST}
	(cd ${WRKSRC}/rel/mongooseim; ${FIND} releases -type f \
		| ${AWK} '{print $$0}' | ${SED} -e 's/^/lib\/mongooseim\//' >> ${PLIST})
	(cd ${WRKSRC}/rel/mongooseim/erts-7.3 ; ${FIND} . -type f \
		| ${AWK} '{print $$0}' | ${SED} 's/\.//' \
		| ${AWK} '{print "lib/mongooseim/erts-7.3"$$0 }' >> ${PLIST})
	(cd ${WRKSRC}/rel; ${FIND} mongooseim/lib -type f \
		| ${AWK} '{print $$0}' | ${SED} -e 's/^/lib\//' >> ${PLIST})
#		| ${AWK} '{print "lib/"$$0 }' >> ${PLIST})
#	${ECHO} "@owner" >> ${PLIST}
#	${ECHO} "@group" >> ${PLIST}

do-install:
.for d in ${MONGOOSEIM_CONFDIR} ${MONGOOSEIM_LOGDIR} ${MONGOOSEIM_DBDIR} ${MONGOOSEIM_LIBDIR} ${MONGOOSEIM_HOMEDIR}
	${MKDIR} ${STAGEDIR}${d}
.endfor
	${INSTALL_DATA} ${WRKSRC}/rel/mongooseim/etc/vm.args ${STAGEDIR}${MONGOOSEIM_CONFDIR}/vm.args.sample
	${INSTALL_DATA} ${WRKSRC}/rel/mongooseim/etc/app.config ${STAGEDIR}${MONGOOSEIM_CONFDIR}/app.config.sample
	${INSTALL_DATA} ${WRKSRC}/rel/mongooseim/etc/ejabberd.cfg ${STAGEDIR}${MONGOOSEIM_CONFDIR}/ejabberd.cfg.sample
	${INSTALL_DATA} ${WRKSRC}/rel/mongooseim/priv/ssl/fake_cert.pem ${STAGEDIR}${MONGOOSEIM_CONFDIR}/cert.pem.sample
	${INSTALL_DATA} ${WRKSRC}/rel/mongooseim/priv/ssl/fake_key.pem ${STAGEDIR}${MONGOOSEIM_CONFDIR}/key.pem.sample
	${INSTALL_DATA} ${WRKSRC}/rel/mongooseim/priv/ssl/fake_server.pem ${STAGEDIR}${MONGOOSEIM_CONFDIR}/server.pem.sample
#	(cd ${WRKSRC}/rel/mongooseim/lib/ && ${COPYTREE_BIN} . ${STAGEDIR}${MONGOOSEIM_LIBDIR})
	${CP} -Rp ${WRKSRC}/rel/mongooseim/lib/* ${STAGEDIR}${MONGOOSEIM_LIBDIR}
#	(cd ${WRKSRC}/rel/mongooseim/bin/ && ${COPYTREE_BIN} . ${STAGEDIR}${PREFIX}/sbin/)
	${CP} -Rp ${WRKSRC}/rel/mongooseim/bin/* ${STAGEDIR}${PREFIX}/sbin
#	(cd ${WRKSRC}/rel/riak/releases && ${COPYTREE_SHARE} . ${STAGEDIR}${RIAK_HOMEDIR}/releases)
	${CP} -Rp ${WRKSRC}/rel/mongooseim/releases  ${STAGEDIR}${MONGOOSEIM_HOMEDIR}
	${CP} -Rp ${WRKSRC}/rel/mongooseim/erts-* ${STAGEDIR}${MONGOOSEIM_HOMEDIR}
#	${INSTALL_MAN} ${WRKSRC}/doc/man/man1/riak.1.gz ${STAGEDIR}${MANPREFIX}/man/man1/
#	${INSTALL_MAN} ${WRKSRC}/doc/man/man1/riak-admin.1.gz ${STAGEDIR}${MANPREFIX}/man/man1/
#	${INSTALL_MAN} ${WRKSRC}/doc/man/man1/riak-debug.1.gz ${STAGEDIR}${MANPREFIX}/man/man1/
#	${INSTALL_MAN} ${WRKSRC}/doc/man/man1/search-cmd.1.gz ${STAGEDIR}${MANPREFIX}/man/man1/

.include <bsd.port.mk>
