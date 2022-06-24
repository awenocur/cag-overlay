# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

SRC_URI="https://github.com/TileDB-Inc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

PATCHES=( "${FILESDIR}/${PN}-0.15.0-test-add-explicit-catch-import.patch" )

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~x86"
IUSE=""
S="${WORKDIR}/${P}/libtiledbvcf"
CMAKE_MAKEFILE_GENERATOR=emake

DEPEND=">=sci-misc/TileDB-2.9
	sci-libs/htslib
	dev-cpp/cli11[single-header]
	>=dev-libs/spdlog-1.9"

BDEPEND="<dev-cpp/catch-2
	dev-cpp/clipp"

src_prepare() {
	cmake_src_prepare
	echo ',s/\(^ *[A-Z]* DESTINATION \)lib$/\1'"$(get_libdir)"'/
w' | ed -s ${S}/src/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS=-DSPDLOG_FMT_EXTERNAL
		-DCMAKE_CXX_FLAGS=-DSPDLOG_FMT_EXTERNAL
		-DFORCE_EXTERNAL_HTSLIB=OFF
		-DFORCE_EXTERNAL_TILEDB=OFF
		-DCATCH_INCLUDE_DIR=/usr/include/catch
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cd ${BUILD_DIR} && DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install-libtiledbvcf
	einstalldocs
}

