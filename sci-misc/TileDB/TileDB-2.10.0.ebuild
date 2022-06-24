# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="The Universal Storage Engine"
HOMEPAGE="https://tiledb.com/"

EGIT_REPO_URI="https://github.com/TileDB-Inc/TileDB.git"
EGIT_COMMIT="0b54e51a08e1a4208e73cdd26aa2e41f67a6840f"

PATCHES=(
	"${FILESDIR}/fix-doc-config.patch"
	"${FILESDIR}/cancel-magic-download.patch"
)

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~x86"
IUSE="doc"
MAGIC_REV="5.38.1.tiledb"
CMAKE_MAKEFILE_GENERATOR=emake


BDEPEND="doc? ( <dev-python/sphinx-4 )
	 >=dev-util/cmake-3.21"

DEPEND="dev-libs/spdlog
	dev-libs/libfmt
	>=dev-cpp/catch-2
	sys-libs/zlib
	app-doc/doxygen
	app-arch/lz4
	"

src_unpack()
{
	git-r3_fetch "https://github.com/TileDB-Inc/file-windows.git" ${MAGIC_REV}
	git-r3_src_unpack
	git-r3_checkout "https://github.com/TileDB-Inc/file-windows.git" ${MAGIC_REV}
	mkdir -p "${BUILD_DIR}/externals/src"
	mv ${WORKDIR}/${MAGIC_REV} "${BUILD_DIR}/externals/src/ep_magic"
}

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
	cd ${BUILD_DIR} && make doc
	use doc && cd ${S}/doc && TILEDB_DIR="${S}" DOX_XML_DIR="${BUILD_DIR}"/xml sphinx-build -E -W -T -b html -d doctrees -D language=en source html
}

src_install() {
	cd ${BUILD_DIR} && DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} install-tiledb
	if `use doc`
	then dodoc -r ${S}/doc/html
	fi
	einstalldocs
}

