#####
# Student ID: 2012-11598
# Description: makefile for Homework 1. # indicates a comment in a bash shell
# Usage: 
#   * make in: run IndegreCounter.jar on Hadoop to compute the in-degree for each node
#   * make out: run OutdegreeCounter.jar on Hadoop to compute the out-degree for each node
#   * make in_dist: run DegreeDistribution.jar on Hadoop to compute the in-degree distribution
#   * make out_dist: run DegreeDistribution.jar on Hadoop to compute the out-degree distribution 

all: in out in_dist out_dist

in:
	hadoop com.sun.tools.javac.Main IndegreeCounter.java
	jar cf IndegreeCounter.jar IndegreeCounter*.class
	rm -rf IndegreeCounter*.class
	hadoop jar IndegreeCounter.jar IndegreeCounter ./soc-LiveJournal1.txt ./output_indegree
	hadoop fs -cat output_indegree/part-r-00000
	hadoop fs -get output_indegree/part-r-00000 output_indegree.txt
#       hadoop jar <jar file> <main class> ./soc-LiveJournal1.txt <output folder>
#	hadoop fs -cat <output file in HDFS>
#	hadoop fs -get <output file in HDFS> <output file in local> 

out:
	hadoop com.sun.tools.javac.Main OutdegreeCounter.java
	jar cf OutdegreeCounter.jar OutdegreeCounter*.class
	rm -rf OutdegreeCounter*.class
	hadoop jar OutdegreeCounter.jar OutdegreeCounter ./soc-LiveJournal1.txt ./output_outdegree
	hadoop fs -cat output_outdegree/part-r-00000
	hadoop fs -get output_outdegree/part-r-00000 output_outdegree.txt


in_dist:
	hadoop com.sun.tools.javac.Main DegreeDistribution.java
	jar cf DegreeDistribution.jar DegreeDistribution*.class
	rm -rf DegreeDistribution*.class
	hadoop jar DegreeDistribution.jar DegreeDistribution ./output_indegree.txt ./output_indist
	hadoop fs -cat output_indist/part-r-00000
	hadoop fs -get output_indist/part-r-00000 output_indist.txt


out_dist:
	hadoop com.sun.tools.javac.Main DegreeDistribution.java
	jar cf DegreeDistribution.jar DegreeDistribution*.class
	rm -rf DegreeDistribution*.class
	hadoop jar DegreeDistribution.jar DegreeDistribution ./output_outdegree.txt ./output_outdist
	hadoop fs -cat output_outdist/part-r-00000
	hadoop fs -get output_outdist/part-r-00000 output_outdist.txt


clean:
	rm -rf output*
	rm -rf *.jar
