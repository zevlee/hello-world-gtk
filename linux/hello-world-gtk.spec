# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
	['../hello-world-gtk'],
	pathex=[],
	binaries=[],
	datas=[
		('../lib/__init__.py', 'lib'),
		('../lib/application.py', 'lib'),
		('../hello-world-gtk.svg', '.'),
		('../LICENSE', '.'),
		('hello-world-gtk.desktop', '.'),
		('.DirIcon', '.')
  ],
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
	debug=False,
	bootloader_ignore_signals=False,
	strip=False,
	upx=True,
	console=False
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
