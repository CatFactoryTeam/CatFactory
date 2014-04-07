#!/usr/bin/python
# coding: utf-8

import os

""" Goes deep down inside 'cats' folder to get each cat 
    And put them at the top of 'cat.js' inside a beautiful js array """
def setup_cat():
	
	path = 'cats'
	arry = 'var cats = ['

	files = os.listdir(path)

	for fname in files:
		if not(fname.endswith('.md')):
	    		arry += "'"+ fname + "'" + ','

	arry = arry[:-1]
	arry += '];'

	return arry

# TODO : remove first line first

factory = open('cat.js', 'r') 
content = factory.read()

factory.close() 

factory = open('cat.js', 'w') 

factory.write(setup_cat()) 
factory.write(content)

factory.close()
