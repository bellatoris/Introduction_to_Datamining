#####
# Student ID: 2015-12345
# Description: makefile for Homework 1. # indicates a comment in a bash shell
# Usage: 
#   * make in: run IndegreCounter.jar on Hadoop to compute the in-degree for each node
#   * make out: run OutdegreeCounter.jar on Hadoop to compute the out-degree for each node
#   * make in_dist: run DegreeDistribution.jar on Hadoop to compute the in-degree distribution
#   * make out_dist: run DegreeDistribution.jar on Hadoop to compute the out-degree distribution 

all: in out in_dist out_dist

in:
#	hadoop jar <jar file> <main class> ./problem.edge <output folder>
#	hadoop fs -cat <output file in HDFS>
#	hadoop fs -get <output file in HDFS> <output file in local> 

out:

in_dist:

out_dist:




