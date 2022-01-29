# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MIRA_3RDPARTY_PV="06-07-2012"
MY_PV="${PV/_}" # convert from mira-4.0_rc2 (Gentoo ebuild filename derived) to mira-4.0rc2 (upstream fromat)

inherit autotools multilib git-r3

DESCRIPTION="Whole Genome Shotgun and EST Sequence Assembler for Sanger, 454 and Illumina"
HOMEPAGE="http://www.chevreux.org/projects_mira.html"
EGIT_REPO_URI="https://github.com/bachev/mira.git"
EGIT_COMMIT="ae5beb03ddbd93978b69fa5bb3658ede9e356e78"
SRC_URI="
	https://master.dl.sourceforge.net/project/mira-assembler/slsstore/rfam_rrna-21-1.sls.gz
	mirror://sourceforge/mira-assembler/mira_3rdparty_${MIRA_3RDPARTY_PV}.tar.bz2"

S="${WORKDIR}"/"${PN}"-"${MY_PV}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

CDEPEND="
	dev-libs/boost:=[threads(+)]
	dev-util/google-perftools"
DEPEND="${CDEPEND}
	sys-devel/flex
	app-editors/vim-core
	dev-libs/expat"
BDEPEND="doc? ( app-text/dblatex )"
RDEPEND="${CDEPEND}"

DOCS=( AUTHORS GETTING_STARTED NEWS README HELP_WANTED
	THANKS )
#DOCS=( AUTHORS GETTING_STARTED NEWS README HELP_WANTED THANKS )

PATCHES=(

)

src_unpack() {
	git-r3_src_unpack
	unpack mira_3rdparty_${MIRA_3RDPARTY_PV}.tar.bz2
	cp ${DISTDIR}/rfam_rrna-21-1.sls.gz $S/src/other/sls/rfam_rrna-21-1.sls.gz
}

src_prepare() {
	find -name 'configure*' -or -name 'Makefile*' | xargs sed -i 's/flex++/flex -+/' || die

	default

	sed \
		-e "s:-O[23]::g" \
		-e "s:-funroll-loops::g" \
		-i configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		--with-boost="${EPREFIX}/usr/$(get_libdir)" \
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)" \
		--with-boost-thread=boost_thread-mt
}

src_compile() {
	default
	emake docs
}

src_install() {
	PATH=${ED}/usr/bin:${PATH} emake install prefix=${ED}/usr

	dobin "${WORKDIR}"/3rdparty/{sff_extract,qual2ball,*.pl}
	dodoc "${WORKDIR}"/3rdparty/{README.txt,midi_screen.fasta}
	dodoc "${S}"/doc/docbook/*.pdf "${S}"/doc/docbook/*.html
}

