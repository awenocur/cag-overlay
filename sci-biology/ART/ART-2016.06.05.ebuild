# Copyright 2019 Adam Wenocur
# Distributed under the terms of the GNU General Public License v2

EAPI=7

#PYTHON_COMPAT=( python2_7 )

inherit eutils

DESCRIPTION="a set of simulation tools to generate synthetic next-generation sequencing reads"
HOMEPAGE="https://www.niehs.nih.gov/research/resources/software/biostatistics/art/index.cfm"

SRC_URI="https://www.niehs.nih.gov/research/resources/assets/docs/artsrcmountrainier${PV}linux.tgz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
#REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=sci-libs/gsl-2
	"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
}

src_unpack() {
	default
	mv art_src_MountRainier_Linux ${S}
}

src_install() {
	default
}
