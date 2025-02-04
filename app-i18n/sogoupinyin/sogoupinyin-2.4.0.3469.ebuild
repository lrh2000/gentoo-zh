# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sogou Pinyin input method."
HOMEPAGE="http://pinyin.sogou.com/linux/"
SRC_URI="amd64? ( http://pinyin.sogou.com/linux/download.php?f=linux&bit=64 -> ${PN}_${PV}_amd64.deb )
x86? ( http://pinyin.sogou.com/linux/download.php?f=linux&bit=32 -> ${PN}_${PV}_i386.deb )
"

LICENSE="Fcitx-Sogou"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=app-i18n/fcitx-4.2.8[X,qt4]
	!app-i18n/fcitx-qimpanel
	net-dns/libidn11
	app-i18n/opencc
	net-libs/libssh2
	media-video/rtmpdump
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	x11-apps/xprop
	sys-apps/lsb-release
	!app-i18n/fcitx-sogoupinyin"
DEPEND="${RDEPEND}"
S=${WORKDIR}

QA_PRESTRIPPED="
/usr/bin/sogou-sys-notify
/usr/bin/sogou-qimpanel-watchdog
/usr/bin/sogou-qimpanel
/usr/lib/fcitx/fcitx-sogoupinyin.so
/usr/lib/fcitx/fcitx-sogoucloudpinyin.so
/usr/lib/fcitx/fcitx-punc-ng.so
/usr/lib/fcitx/fcitx-fullwidth-char-enhance.so
/usr/lib/fcitx/fcitx-autoeng-ng.so
"

src_compile(){
	tar xf "${WORKDIR}/data.tar.xz"
	rm control.tar.gz data.tar.xz debian-binary
	#  rm -rf usr/share/fcitx-qimpanel
	rm -rf usr/share/keyrings
	rm -rf etc/X11
}

src_install(){
	dodir /usr/$(get_libdir)/fcitx
	insinto /usr/$(get_libdir)/fcitx
	insopts -m0755
	doins "${S}"/usr/lib/*-linux-gnu/fcitx/*
	dodir /usr/share/mime-info
	insinto /usr/share/mime-info
	install -D "${S}/usr/lib/mime/packages/fcitx-ui-sogou-qimpanel" fcitx-ui-sogou-qimpanel.keys
	dodir /usr/share
	insinto /usr/share
	doins -r "${S}"/usr/share/*

	dodir /usr/bin
	insinto /usr/bin
	doins "${S}"/usr/bin/*
	dodir /etc/xdg/autostart
	insinto /etc/xdg/autostart
	doins "${S}"/etc/xdg/autostart/*

#  dodir /usr/lib
#  insinto /usr/lib
#  dosym libcurl.so.4 /usr/lib/libcurl-gnutls.so.4
#  dosym libgnutls.so /usr/lib/libgnutls.so.26
#  dosym librtmp.so /usr/lib/librtmp.so.0
}

pkg_postinst(){
	einfo
	einfo "After install the fcitx-sogoupinyin, a restart of fcitx is"
	einfo "expected."
	einfo
	einfo "if you see 请启用sogou-qimpanel面板程序，以便更好的享受搜狗输入法！"
	einfo "relogin to your desktop, or just start sogou-qimpanel"
}
