# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MIRA_3RDPARTY_PV="06-07-2012"
MY_PV="${PV/_}" # convert from mira-4.0_rc2 (Gentoo ebuild filename derived) to mira-4.0rc2 (upstream fromat)

inherit autotools multilib

DESCRIPTION="Whole Genome Shotgun and EST Sequence Assembler for Sanger, 454 and Illumina"
HOMEPAGE="http://www.chevreux.org/projects_mira.html"
SRC_URI="
	https://sourceforge.net/projects/mira-assembler/files/MIRA/development/${P}.tar.bz2
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
	"${FILESDIR}/${PN}-4.9.6-fix-install-path-prepare.patch"
)

src_prepare() {
	find -name 'configure*' -or -name 'Makefile*' | xargs sed -i 's/flex++/flex -+/' || die

	default

	sed \
		-e "s:-O[23]::g" \
		-e "s:-funroll-loops::g" \
		-i configure.ac || die

	eautoreconf

	# Remove C++ source files that upstream built with flex.
	local f
	local PREBUILT_CXX_LEXER_FILES=(
		"${S}"/src/caf/caf_flexer.cc
		"${S}"/src/io/exp_flexer.cc
		"${S}"/src/mira/parameters_flexer.cc
	)

	for f in "${PREBUILT_CXX_LEXER_FILES[@]}"; do
		if [[ -f ${f} ]] ; then
			rm "${f}" || die "Failed to remove ${f}"
		else
			die "${f} not found"
		fi
	done
	eapply "${FILESDIR}/${PN}-4.9.6-fix-install-path.patch"
}

src_configure() {
	econf
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

