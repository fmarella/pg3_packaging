#!/usr/bin/env python
# -*- coding: utf-8 -*-

#    Copyright (C) 2005, 2006, 2007 2008, 2009, 2010 by Promotux
#                        di Francesco Meloni snc - http://www.promotux.it/

#    Author: Francesco Meloni  <francesco@promotux.it>

#    This file is part of Promogest.

#    Promogest is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.

#    Promogest is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with Promogest.  If not, see <http://www.gnu.org/licenses/>.

import os
import pysvn
import time
client = pysvn.Client()
#check out the current version of the pysvn project
if os.name == "nt":
    dove = os.environ['APPDATA']+os.sep
else:
    dove = os.path.expanduser('~')+os.sep
if os.path.exists(dove+'pg3/core'):
    os.rmdir(dove+'pg3/core')
print "ATTENZIONE ...\n\n INIZIO LO SCARICAMENTO DEL CODICE SORGENTE PROMOGEST...\n\n L'OPERAZIONE POTREBBE RICHIEDERE ANCHE ALCUNI MINUTI \n\nATTENDERE..."
print client.checkout('http://promogest.googlecode.com/svn/trunk',
    dove+'pg3')
print "TERMINATO LO SCARICAMENTO DEL PROGRAMMA ....CONTINUAMO CON L'INSTALLAZIONE"
time.sleep(3)
