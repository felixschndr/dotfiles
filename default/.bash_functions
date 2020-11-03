#!/bin/bash

search_function(){
	grep -r "${1}" ./* 
}

alias search='search_function'
