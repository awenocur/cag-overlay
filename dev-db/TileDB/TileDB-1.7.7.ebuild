# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils eutils

DESCRIPTION="The Fastest Array Storage Engine"
HOMEPAGE="https://tiledb.com"
SRC_URI="https://github.com/TileDB-Inc/TileDB/archive/${PV}.zip -> ${P}.zip
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	>=app-arch/zstd-1.3.4
	>=dev-cpp/tbb-2018.3
	>=dev-cpp/catch-2.2.1
	>=dev-libs/spdlog-0.16.3
"
RDEPEND=${DEPEND}

src_prepare() {
cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCATCH_INCLUDE_DIR=/usr/include/catch2
	)
	mkdir -p ${WORKDIR}/${P}_build/externals/src
	cmake-utils_src_configure
}