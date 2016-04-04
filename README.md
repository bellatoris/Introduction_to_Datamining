# Introduction_to_Datamining
<img src = "https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/IMG_2568.GIF">
##Lecture \#6: Mining Data Streams
###Queries Over Sliding Window
##4월 4일
####How to Query?
* To estimate the number of 1s in the most recent N bits:
   1. Sum the sizes of all buckets but the last  
      (note "size" means the number of 1s in the bucket)
   2. Add half the size of the last bucket
* Remember: We do not know how many 1s of the last bucket are still within the wanted window

####Example: Bucketized Steam
![Pic41](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%EC%A0%84%2011.58.50.png)

####Error Bound: Proof
* Why is error 50%? Let's prove it! (error = |x_hat - x| / x)
* Suppose the last bucket has size 2^r
* Then bu assuming 2^(r - 1) (i.e., half) of its 1s are still within the window, we make an error at most 2^(r -1) -> largest error (e.g., 마지막 bucket의 sliding window안에 존재하는 1의 개수가 실제로는 1개인데 2^(r - 1)로 추정했을 경우의 error)
* Since there is at least one bucket of each of the sizes less than 2^r, the true sum is at least  
   1 + 2 + 4 + ... + 2^(r - 1) = 2^r - 1 (실제로는 각 size에 해당하는 bucket의 개수가 최대 2개 이므로 이보다 클 수 있다.)
* Thus error is at most 50% (error = |x_hat - x| / x = 2^(r - 1) / 2^r = 0.5)

####Further Reducing the Error
* Instead of maintaining 1 or 2 of each size bucket, we allow either k - 1 or k buckets (k > 2)
   * Except for the largest size buckets; we can have any number between 1 and k of those
* Error is at most O(1/k)
   * k가 커질수록 largest bucket의 size는 줄어들 것이다. 즉 sliding window의 맨왼쪽에 걸쳐있는 bucket의 size가 줄어드므로 error는 줄어들게 된다 ((x_hat - x)의 크기가 줄어드므로).
   * Largest bucket의 size가 2^r이라 가정해보자.  
      x_hat - x <= 2^(r - 1)  
      true sum >= (k - 1) * (2^r - 1) (각 size마다 적어도 k - 1개의 bucket이 존재하므로)  
      error = O(1/k)
* By picking r appropriately, we can tradeoff between number of bits we store and the error
   * Increasing r => more memory space (more small size bucket), less error
   * 그렇다면 얼마나 많은 memroy공간이 필요한 것일까?  
      Largest bucket의 size가 2^r이라 했을 때 대략 (k - 1) * (2^(r + 1) - 1)  = N 이라 한다면
      r = log(N/k)이 된다.  
      Total number of buckets = O(k * log(N/k))

####Extensions
* Can we use the same trick to answer queries "How many 1's in the last k?" where k < N?
   * A: Find earliest bucket B that at overlaps with k. Number of 1s is the sum of sizes of more recent buckets + 1/2 size of B
   ![Pic44](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.03.09.png)
   * 앞서 해왔던 방법과 exactly하게 동일하다.

* Can we handle the case where the steam is not bits, but integers, and we want the sum of the last k elements?
* Steam of positive integers
* We want the sum of the lst k elements
   * Amazon: Avg. prive of last k sales
* Solution:
   * If you know all integers have at most m bits
      * Treat m bits of each intefer as a separate stream
      * Use DGIM to count 1s in each integer
      * The sum is Sigma (i = 0 to m - 1) {c_i * 2^i}
         * c_i ...estimated count for i-th bit

####Summary
* Sampling a fixed proportion of a stream
   * Sampe size grows as the stream grows
* Samlping a fixed-size sample
   * Reservoir sampling
* Counting the number of 1s in the last N elements
   * Exponentially increasing windows
   * Extensions:
      * Number of 1s in any last k (k < N) elements
      * Sums of integers in the last N elements

##Lecture \#7: Mining Data Streams-2
####Today's Lecture
* More algorithms for streams:
   * (1) Filtering a data steam: Bloom filters
      * Select elements with property x from stream
   * (2) Counting distinct elements: Flajolet-Martin
      * Number of distinct elements in the last k elements of the stream

###Filtering Data Stream
####Motivating Applications
* Example: Email spam filtering
   * We know 1 billion "good" email addresses
   * If an email comes from one of these, it is **NOT** spam
* Publish-subscribe systems
   * You are collecting lots of messages (new articles)
   * People express interest in certain sets of keywords
   * Determine whether each message matches user's interest

####Filtering Data Steams
* Each element of data stream is a tuple
* Given a list of keys **S**
* Determine which tupes of stream are in s
* Obivious solution: Hash table
   * 즉 모든 key **S**를 Hashing 해서  bucket에 넣어두고 (conflicts 없이) Streaming data가 오면 hashing해서 같은 bucket에 들어가면 "good" email 그렇지 않으면 spam으로 취급한다.
   * But suppose we do not have enough memory to sotre allof **S** in a hash table
      * E.g., we might be processing millions of filters on the same stream 

####First Cut Solution
* Given a set of keys S that we want to filter
* Create a bit array B of n bits, initially all 0s
* Choose a hash function h with range [0,n)
* Hash each member of s in **S** to one of n buckets, and set that bit to 1, i.e., B[h(s)] = 1
* Hash each element a of the stream and output only those that hash to bit that was set to 1
   * Output a if B[h(a)] == 1
![Pic7-7](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.53.20.png)
* Creates false positives but no false negatives
   * If the item is in **S** we surely output it, if not we may still output it
* |S| = 1 billion email addresses  
|B| = 1GB = 8 billion bits
* If the email address is in **S**, then it surely hashes to a bucket that has the bit set to 1, so it always gets through (*no false negatives*)
* Approcimately 1/8 of the bits are set to 1, so about 1/8th of the addresses not in S get through to the output (*false positives*)
   * Actually, less than 1/8th, because more than one address might hash to the same bit
   
####Analysis: Throwing Darts
* More accurate analysis for the number of false positives
* Consider: If we throw m darts into n equally likely targets, **what is the probability that a target gets at leasr one dart?**
   * n = bucket의 size
   * m = list of keys (e.g., "good" mail list)
* In our case:
   * **Targets** = bits/buckets
   * **Darts** = hash values of items
* We have *__m__* darts, *__n__* targets
* What is the probability that a target gets at least one dart?
![Pic7-10](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.53.35.png)
* Fraction of 1s in the array B = probability of false positive = 1 - e^(-m/n)
* Example: 10^9 darts, 8 * 10^9 targets
   * Fraction of 1s in **B** = 1 - e^(-1/8) = 0.1175
      * Compare with our earlier estimate: 1/8 = 0.125

####Bloom Filter
* Consider: |S| = m, |B| = n
*  Use k independent hash gunctions h_1, ..., h_k
*  Initialization:
   * Set **B** to all **0s**
   * Hash each element **s in S** using each hash function *__h_i__*, set B[*__h_i(s)__*] = 1 (for each *__i = 1,...,k__*)
      * note: we have a single array B!
      * 즉 각각의 s에 대해서 k번 hashing한다.
* Run-time:
   * When a stream element with key *__x__* arrives 
      * That is, *__x__* hashes to a bucket set to **1** for every hash function *__h_i(x)__*
   * Otherwise discard the element *__x__*
   * x를 k번 hashing한 결과 k개의 h_i[x]가 모두 1로 set되어 있어야 "good" mail로 받아들인다.

####Bloom Filter -- Analysis
* WHat fraction of the bit vector B are 1s?
   * Throwing *__km__* darts at *__n__* targets   
   * So fraction of **1s** is *(1 - e^(-km/n))*
* But we have *__k__* independent hash functions ans we only let the element *__x__* through **if all k** hash element *__x__* to a bucket of value **1**
* So, false positive probability = *__(1 - e^(-km/n))^k__*  <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.53.47.png" height="300"  align="right"> <br><br>
* m = 1 billion, n = 8 billion
   * k = 1: (1 - e^(-1/8)) = 0.1775  
   * k = 2: (1 - e^(-1/4))^2 = 0.0493<br><br>
* What happens as we keep increasing k?
   * Bucket이 모두 1로 되어버려서 모든 mail을 "good" mail이라고 받아들이게 된다.<br><br>
* "Optimal" value of k: n/m * ln(2)
   * In out case: Optimal k = 8 * ln(2) = 5.54 ~= 6
      * Error at k = 6: (1 - e^(-1/6))^2 = 0.0235

####Bloom Filter: Wrap-up
* Bllom filters guarantee no false negatives, and use limited memory
   * Great for pro-processing before more expensive checks
* Suitable for hardware implementation
   * Hash gunction compustations can be parallelized<br><br>
* It it better to have **1 big B** or **k small Bs**?
   * **It is the same:** *(1 - e^(-km/n))^k* vs. *(1 - e^(-m/(n/k)))^k*
   * But keeping **1 big B** is simpler
   * 여기서 k small Bs란 각각의 hash function마다 Bucket을 따로 두는 것을 말한다. 큰 Bucket 하나를 쓰나 작은 Bucket 여러개를 쓰나 그 결과는 동일하다.

###Counting Distinct Elements
####Motivating Applications
* How many different words are found among the Web pages being crawled at a site?
 * Unusually low or high numbers could indicate articial pages (spam?)<br><br>
* How many different Web pages dows each customer request in a week?<br><br>
* How many distinct products hace we sold in the last week?

####Counting Distinct Elements
* Problem:
   * Data stream consists of a universe of elements chosen form a set of size ***N***
   * Maintain a count of the number of distinct elements seen so far
* Obvious approach:  
Maintain the set of elements seen so far
   * That is, keep a hash table of all the distinct elements so far
   * 그러나 이 경우에 set of elements가 너무 커서 memory에 fit하지 않을 수 있다.
   
####Using Small Storage
* Real problem: What if we don not have space to maintain the set of elements seen so far?<br><br>
* Estimate the count in an unbiased way -> E(X_hat) = E(X)<br><br>
* Accept that the count may have a little error, but limit the probability that the error is large

####Flajolet-Martin Approach **(O(N)의 memory space 공간을 O(log(N))으로 줄일 수 있다!)**
* Hash each item x to a bit, using exponential distribution
   * 1/2 map to bit 0, 1/4 map to bit 1, ...
   ![Pic7-20](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.54.08.png)
* Let R be position of the least '0' bit
* [Flajolet, Martin]: the number of distinct items is 2^R/***phi***, where ***phi*** is a constant
