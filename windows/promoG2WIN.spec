# -*- mode: python -*-
a = Analysis([os.path.join(HOMEPATH,'support\\_mountzlib.py'), os.path.join(HOMEPATH,'support\\useUnicode.py'), 'pg2\\core\\promoG2WIN.pyw'],
             pathex=['C:\\Promogest'])
pyz = PYZ(a.pure)
exe = EXE( pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          name=os.path.join('dist', 'promoG2WIN.exe'),
          debug=False,
          strip=False,
          upx=True,
          console=True )
