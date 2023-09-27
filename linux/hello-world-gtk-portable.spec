# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
	['../helloworldgtk.py'],
	pathex=[],
	binaries=[],
	datas=[
		('../helloworldgtk', 'helloworldgtk'),
		('../org.example.HelloWorldGTK.svg', '.'),
		('../LICENSE', '.'),
		('../VERSION', '.'),
		('hello-world-gtk.desktop', '.')
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
	a.binaries,
	a.zipfiles,
	a.datas,
	[],
	name='hello-world-gtk',
	debug=False,
	bootloader_ignore_signals=False,
	strip=False,
	upx=True,
	upx_exclude=[],
	console=False
)
