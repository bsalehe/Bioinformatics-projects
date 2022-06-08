import os
import shutil
from os import path
#
#
county_names_list = ['Aberdeenshire','Anglesey','Angus','Antrim','Argyllshire','Armagh','Ayrshire','Banffshire','Bedfordshire','Berkshire','Berwickshire','Brecknockshire','Buckinghamshire','Buteshire','Caernarvonshire','Caithness','Cambridgeshire','Cardiganshire','Carlow','Carmarthenshire','Cavan','Cheshire','Clare','Cork','Cornwall','Cumberland','Denbighshire','Derbyshire','Derry','Devon','Donegal','Dorset','Down','Dublin','Dumfriesshire','Dunbartonshire','Durham','East','Lothian','Essex','Fermanagh','Fife','Flintshire','Galway','Glamorgan','Gloucestershire','Hampshire','Herefordshire','Hertfordshire','Huntingdonshire','Invernessshire','Isle','of','Man','Isle','of','Wight','Kent','Kerry','Kildare','Kilkenny','Kincardineshire','Kirkcudbrightshire','Lanarkshire','Lancashire','Laois','Leicestershire','Leitrim','Limerick','Lincolnshire','Longford','Louth','Mayo','Meath','Merionethshire','Mid','Lothian','Middlesex','Monaghan','Monmouthshire','Montgomeryshire','Morayshire','Nairnshire','Norfolk','Northamptonshire','Northumberland','Nottinghamshire','Offaly','Orkney','Islands','Outer','Hebrides','Oxfordshire','Peeblesshire','Pembrokeshire','Perthshire','Radnorshire','Renfrewshire','Roscommon','Ross','and','Cromarty','Roxburghshire','Selkirkshire','Shetland','Islands','Shropshire','Sligo','Somerset','Staffordshire','Stirlingshire','Suffolk','Surrey','Sussex','Sutherland','Tipperary','Tyrone','Warwickshire','Waterford','West','Lothian','Westmeath','Westmorland','Wexford','Wicklow','Wigtownshire','Wiltshire','Worcestershire','Yorkshire']

#county_names_empty_list=[]

#src = r'/home/bajuna/bioinf_projects/julie_plants/data/for Bajuna/output1_118_county_medicinal_plants_xlsx/output2'
dest = r'/home/bajuna/bioinf_projects/julie_plants/data/for Bajuna/output1_118_county_medicinal_plants_xlsx/output2/output_3'

#src_files = os.listdir(src)

#for county_names in county_names_list:
#	if county_names not in county_names_empty_list:
#		full_file_name = os.path.join(src, file_name)
#                     
#
rootDir = '.'
i = 0
for dirName, subdirList, fileList in sorted(os.walk(rootDir)):
    #print('Found directory: %s' % dirName)
    for fname in fileList:
      print('\t%s' % fname)
      #filename = os.path.join(dirName, fname)
      if fname == 'summary_results_null_populations.xlsx':
	#fname = county_names_list[i+1]+'_'+fname
	#shutil.copy(fname, dest)
	#src = path.realpath(fname)
	for dirName in subdirList:
	   if dirName == './output_3':
	     os.rename(filename, dirName+'/'+county_names_list[i+1]+'_'+fname)
