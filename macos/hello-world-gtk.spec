# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
	['../hello-world-gtk'],
	pathex=[],
	binaries=[],
	datas=[
		('../lib', 'lib'),
		('../org.example.HelloWorldGTK.svg', '.'),
		('../LICENSE', '.'),
		('../VERSION', '.')
	],
	hooksconfig={
		'gi': {
			'icons': ['Adwaita'],
			'themes': ['Adwaita'],
			'module-versions': {
				'Gtk': '4.0'
			}
		}
	},
	hiddenimports=[],
	hookspath=[],
	runtime_hooks=[],
	excludes=[],
	win_no_prefer_redirects=False,
	win_private_assemblies=False,
	cipher=block_cipher,
	noarchive=False
)

pyz = PYZ(
	a.pure,
	a.zipped_data,
	cipher=block_cipher
)

exe = EXE(
	pyz,
	a.scripts,
	[],
	exclude_binaries=True,
	name='hello-world-gtk',
	icon='hello-world-gtk.icns',
	debug=False,
	bootloader_ignore_signals=False,
	strip=False,
	upx=True,
	console=False,
	codesign_identity='',
	entitlements_file='entitlements.plist'
)

coll = COLLECT(
	exe,
	a.binaries,
	a.zipfiles,
	a.datas,
	strip=False,
	upx=True,
	upx_exclude=[],
	name='hello-world-gtk'
)

app = BUNDLE(
	coll,
	name='Hello World.app',
	icon='hello-world-gtk.icns',
	bundle_identifier='org.example.HelloWorldGTK',
	version='VERSION'
)
