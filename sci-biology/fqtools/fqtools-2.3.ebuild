# Copyright 2019 Adam Wenocur
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#PYTHON_COMPAT=( python2_7 )

inherit eutils

DESCRIPTION="An efficient FASTQ manipulation suite"
HOMEPAGE="https://github.com/alastair-droop/fqtools"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
#REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=sci-libs/htslib-1.0
	sys-libs/ncurses:0=
	sys-libs/zlib:="
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
}

src_install() {
	dobin bin/fqtools
	dodoc README.md
}
