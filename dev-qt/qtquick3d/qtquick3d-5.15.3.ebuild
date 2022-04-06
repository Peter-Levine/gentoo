# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=1ede2ac20170357b3e8d7d9810e5474e08170827
inherit qt5-build

QT5_KDEPATCHSET_REV=1

DESCRIPTION="A high level 3D API for Qt Quick"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

IUSE="tools"

RDEPEND="
	=dev-qt/qtdeclarative-${QT5_PV}*
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*
	>=media-libs/assimp-5.2.3
"
DEPEND="${RDEPEND}"

src_unpack() {
	default

	unpack "${FILESDIR}"/${P}-gentoo-kde-1.tar.xz
}
src_prepare() {
	qt5-build_src_prepare
	rm -r src/3rdparty || die
	use tools || rm -r tools || die
}
