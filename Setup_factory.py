#!/usr/bin/python
# coding: utf-8

import os

""" Goes deep down inside 'cats' folder to get each cat 
    And put them at the top of 'cat.js' inside a beautiful js array """
def setup_cat():
	
	path = 'cats'
	arry = 'var cats = ['

	files = os.listdir(path)

	# TODO : a real image collector (not just ignoring '.md')

	for fname in files:
		if not(fname.endswith('.md')):
	    		arry += "'"+ fname + "'" + ','

	arry = arry[:-1]
	arry += '];\n'

	return arry

# TODO : remove first line first

catjs = 'js/cat.js'

factory = open(catjs, 'r')
content = factory.read()

factory.close() 

factory = open(catjs, 'w') 

factory.write(setup_cat()) 
factory.write(content)

factory.close()