# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

SRC_URI="https://github.com/TileDB-Inc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"


SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~x86"
IUSE=""


DEPEND="dev-libs/spdlog
	dev-libs/libfmt
	>=dev-cpp/catch-2
	sys-libs/zlib
	app-doc/doxygen
	app-arch/lz4
	"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS=-DSPDLOG_FMT_EXTERNAL
		-DCMAKE_CXX_FLAGS=-DSPDLOG_FMT_EXTERNAL
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cd ${BUILD_DIR} && DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install-tiledb
	einstalldocs
}

