# Introduction_to_Datamining
<img src = "https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/IMG_2568.GIF">
##Lecture \#6: Mining Data Streams
###Queries Over Sliding Window
***
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
* Then by assuming 2^(r - 1) (i.e., half) of its 1s are still within the window, we make an error at most 2^(r -1) -> largest error (e.g., 마지막 bucket의 sliding window안에 존재하는 1의 개수가 실제로는 1개인데 2^(r - 1)로 추정했을 경우의 error)
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
   * 그렇다면 얼마나 많은 memory공간이 필요한 것일까?  
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
***
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
* Consider: If we throw m darts into n equally likely targets, **what is the probability that a target gets at least one dart?**
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
* 결국 모든 key (in S)들을 hashing했을 때 B가 얼마나 1로 채워질지를 구하는 것이다.

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
   * B가 더 많이 1로 채워지긴 하겠지만 x도 모두 맞춰야 하므로 optimal한 값을 찾으면 dart를 한번 던졌을 때 보다 false positive의 확률이 낮아질 것이다.

####Bloom Filter -- Analysis
* What fraction of the bit vector B are 1s?
   * Throwing *__km__* darts at *__n__* targets   
   * So fraction of **1s** is *(1 - e^(-km/n))*
* But we have *__k__* independent hash functions ans we only let the element *__x__* through **if all k** hash element *__x__* to a bucket of value **1**
   * Dart ***km***개를 다 맞춰야 "good" mail
* So, false positive probability = *__(1 - e^(-km/n))^k__*  <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.53.47.png" height="300"  align="right"> <br><br>
* m = 1 billion, n = 8 billion
   * k = 1: (1 - e^(-1/8)) = 0.1775  
   * k = 2: (1 - e^(-1/4))^2 = 0.0493<br><br>
* What happens as we keep increasing k?
   * Bucket이 모두 1로 되어버려서 모든 mail을 "good" mail이라고 받아들이게 된다.<br><br>
* "Optimal" value of k: ***n/m * ln(2)***
   * In out case: Optimal k = 8 * ln(2) = 5.54 ~= 6
      * Error at k = 6: (1 - e^(-1/6))^2 = 0.0235

####Bloom Filter: Wrap-up
* Bloom filters guarantee no false negatives, and use limited memory
   * Great for pro-processing before more expensive checks
* Suitable for hardware implementation
   * Hash gunction compustations can be parallelized<br><br>
* It it better to have **1 big B** or **k small Bs**?
   * **It is the same:** *(1 - e^(-km/n))^k* vs. *(1 - e^(-m/(n/k)))^k*
   * But keeping **1 big B** is simpler
   * 여기서 k small Bs란 각각의 hash function마다 Bucket을 따로 두는 것을 말한다. 큰 Bucket 하나를 쓰나 작은 Bucket 여러개를 쓰나 그 결과는 동일하다.

###Counting Distinct Elements
***
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

##4월 6일

####Flajolet-Martin Approach **(O(N)의 memory space 공간을 O(log(N))으로 줄일 수 있다!)**
* Hash each item x to a bit, using exponential distribution
   * 1/2 map to bit 0, 1/4 map to bit 1, ...
   ![Pic7-20](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.54.08.png)
* Let R be position of the least '0' bit
* [Flajolet, Martin]: the number of distinct items is 2^R/***phi***, where ***phi*** is a constant
* 추가적인 설명:  hashing 했을 때 그 결과가 0 이 나올 확률이 1/2, 1이 나올 확률이 1/4, ... , n이 나올 확률이 (1/2)^(n+1)이다. 위의 그림에서 array의 왼쪽이 index가 작은쪽이다.
* 지금 R = 3이므로 the number of distinct itme = 2^R/***phi***

####Intuition
* Hash each item x to a bit, using exponential distribution: 1/2 map to bit 0, 1/4 map to bit 1, ...  
   ![Pic7-21](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.54.08.png)
* Intuition
    * The 0_th bit is accessed with prob. 1/2
    * The 1_st bit is accessed with prob. 1/4
    * ... The k_th bit is accessed with prob. (1/2)^(k+1) -> O(1/2^(k+1)) -> O(1/2^k)
    * k번째 bit가 1이 나올 확률 1/2^(k+1) -> 2^(k+1)개의 item을 넣었을 때 기댓값 = 1  
    그러므로 우리의 distinct item의 개수는 대략 2^(k+1)개 일 것이다.  
    그런데 우리는 last one bit index를 사용하지 않고 least zero bit index를 사용! -> 2^(k+1)/***phi***가 전체 distinct item의 개수 (k가 last one bit inedex라 했을 때)
    * last one bit을 사용하지 않고 least zero bit을 사용하는 이유는... 논문에 나와있다!  
    그런데 생각해보면 k번째 bit가 1이 나올 기댓값을 1로 만들어 주기 위해서는 2^(k+1)이 필요하니까 그냥 편하게 R = k+1이니까 R을 선택한 것이 아닐까?

####Improving Accuracy
* Hash each item x to a bit, using exponential distribution: 1/2 map to bit 0, 1/4 map to bit 1, ...  
   ![Pic7-21](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.54.08.png)
* Map each item to ***k*** different bitstrings, and we compute the **average** least '0' bit poition b: # of items = 2^b/***phi***
    * => decrease the variance
    * 즉 k번 hashing해서 그 결과를 평균취하면 그 random variable의 평균은 동일하지만 분산은 낮아진다. (god changhyun)<br><br>
* The final estimate: 2^b / (0.77351 * *bias*)
    * b: average least zero bit in the bitmask
    * bias: 1 + .31/k for k different mappings (k different hashing)

####Random Hash Function
* Hash each item to x to a bit, using exponential distribution
    * 1/2 map to bit 0, 1/4 map to bit 1,... <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-04%20%EC%98%A4%ED%9B%84%2012.54.24.png" align="right" height="50">
* How can we get this function?
    * Typically, a hash function maps an item to a random bucket<br><br>
* Answer: use linear hash funcitons. Pick random (a_i, b_i) and then then the hash funciton is:
    * *lhash_i(x)* = a_i \* x + b_i
    * This gives uniform distribution over the bits
    * 즉 모든 bit들이 1이 될 확률은 1/2로 동일하다.<br><br>
* To make this exponential, define
    * *hash_i(x)* = least zero bit index in *lhash_i(x)* (in binary format)
    * 모든 bit들이 1이 될 확률은 1/2로 동일하기 때문에
        1. p(least zero bit index == 0) = 1/2
        2. p(least zero bit index == 1) = 1/4 (array의 2번 째 bit에서 처음으로 0이 나와야 하므로 1/2 \* 1/2)
        3. p(least zero bit index == k) = 1/2^(k+ 1)

####Storage Requirement
* Flajolet-Martin:
    * Let R be the position of the least '0' bit
    * The number of distinct items is 2^R/***phi***, where phi is a constant<br><br>
* How much storage do we need?
    * R bits are required to count a set with 2^R/***phi*** = O(2^R) distinct items.
    * Thus, given a set with N distinct items, we need only O(log N) bits.

##Lecture \#8: Mining Data Streams-3
###Estimating Moments
***
####Generalization: Moments
* Suppose a stream has elements chosen from a set A of N values<br><br>
* Let *m_i* be the number of times value i occurs in the stream<br><br>
* The k_th ***moment*** is <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.30.53.png" height="50" align="center" hspace="5"><br><br>
* E.g., for a stream (x, y, x, y, z, z, z, x, z),
    * The 2_nd moment is 3^2 + 2^2 + 4^2 = 29
    * (x appears  3 times, y appears 2 times, z appears 4 times)

####Special Cases
<img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.30.53.png" height="80" align="center" hspace="300">
* **0_th moment** = number of distinct elements
    * The problem considered in the last lecture
* **1_st moment** = count of the numbers of elements = length of the stream
    * Easy to compute
* **2_nd moment** = ***surprise number S*** =  
    a measure of how uneven the distribution is

####Example: Surprise Number
* Stream of length 100
* 11 distinct values<br><br>
* Item counts: 10, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 **Surprsie S = 910**<br><br>
* Item counts: 90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 **Surprise S = 8,110**<br><br>

####Problem Definition
* Q: Given a stream, how can we estimate k_th moments efficiently, with small memory space?<br><br>
* A: AMS method

####AMS Method
* AMS method works for all moments
* Gines an unbiased setimate
* We first concentrate on the 2_nd moment S
* We pick and keep track of many variables ***X***:
    * For each variable ***X*** we store ***X.el*** and ***X.val***
        * ***X.el*** corresponds to the item ***i***
        * ***X.val*** corresponds to the **count** of item ***i***
    * Note this requries a count in main memeory, so number of ***X***s is limited
* **Our goal is to compute S =** <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.31.42.png" align="center" height="30">

####One Random Variable (X)
* How to set ***X.val*** and ***X.el***?
    * Assume stream has length **n** (we relax this later)
    * Pick some random time **t (t < n)** to start, so that any time is equally likey
    * If the stream have item ***i*** at time **t**, we set ***X.el = i***
    * Then we maintain count **c** (***X.val = c***) of the number of s ***i***s in the stream starting from the chosen time **t**
* Then the estimate of 2_nd moment (<img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.31.42.png" align="center" height="30">) is:  
<img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%209.39.32.png" align="center" height="40" hspace="200">
    * Note, we will keep track of mulitple Xs, (X_1, X_2,...,X_k) and our final estimate will be  
    S = <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%209.35.56.png" align="center" height="30">
    * 마찬가지로 평균을 취해주는 의미는 random variable의 평균을 유지하고 variance를 낮춰서 신뢰도를 올리기 위함이다.

####Expectation Analysis
![Pic8-9](https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%209.46.33.png)
* 2_nd moment is <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%209.46.47.png" align="center" height="30">
* c_t ... number of times item at time **t** appears from time **t** onwards ***(c_1 = m_a, c_2 = m_a - 1, c_3 = m_b)***
<img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%209.46.56.png" align="right" height="100">
* **E[f(X)] =** <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%209.47.37.png" align="center" height="38">  
<img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%209.52.27.png" align="center" height="120">
* 간단하게 생각하면 위의 식은 다음과 같이 생각할 수 있다.
    * t = 1 부터 n까지 모든 c_t를 더한다는 것은 모든 item i에 대하여 1부터 i가 총 나온 횟수(= m_i)까지 더한다는 것이다.
    * 이러한 관계를 생각하여 풀어 쓴 식이 위의 식이다.
* E[f(***X***)] = <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.55.16.png" align="center" height="38">
    * Little side calculation: (1 + 3 + 5 + ... + 2m_i - 1) =  
     <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.55.21.png" align="center" height="38">
* Then E[f(***X***)] = <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.55.29.png" align="center" height="43"><br><br>
* So, E[f(***X***)] = <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.55.34.png" align="center" height="33"> **= S**
* We have the second moment (in expectation)!
* 우리는 모든 **t**에 대해서 더하지 않을 것이기 때문에 in expectation인 것이다.

####Higher-Order Moments
* For estimating k-th moment we essentially use the same algoritm but change the estimate:
    * For **k=2** we used n(2\*c - 1)
    * For **k=3** we use: n(3\*c^2-3\*c+1) (where **c = X.val**)
* Why?
    * For k=2: Remember we had (1 + 3 + 5 + ... + 2m_i - 1) and we showed terms ***2c -1*** (for c = 1,...,m) sum to m^2
        * <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%2010.35.08.png" align="center" height="35">
        * So:<img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%2010.40.03.png" align="center" height="30">
    * For k=3: <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%2010.40.09.png" align="center" height="30">
* Generally: Estimate = <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%2010.40.19.png" align="center" height="30">

####Combining Samples
* In practive:
    * Compute f(***X***) = n(2c - 1) for as many variables ***X*** as you can fit in memory
    * Average them<p>
* Problem: Streams never end
    * We assumed there was a number ***n***, the number of positions in the stream
    * But real streams go on forever, so ***n*** is a variable - the number of inputs seen so far

####Streams Never End: Fixups
* (1)f(***X***) = n(2c - 1) have ***n*** as a factor - keep ***n*** separately; just hold the count c in ***X***
* (2) Suppose we can only store ***k*** counts. We must throw some ***X***s out as time goes on:
    * Objective: Eaxh starting time ***t*** is selected with probability ***k/n***
    * Solution: (fixed-size sampling = reservoir sampling!)
        * Choose the first ***k*** times for ***k*** variables
        * When the ***n_th*** element arrves (***n > k***), choose it with probabiltiy ***k/n***
        * If you choose it, throw one of the previously stored variables **X** out, with equal probability
        * n은 그냥 stream의 length이니까 계속 변하게 납두고, k개의 count만 저장한다. 새로운 item이 올때 bucket에 넣을 확률은 k/n이다. -> reservoir sampling!

##Counting Frequent Items
####Counting Itemsets
* New Problem: Given a stream, how can we find recent frequent items (= which appear more than s times int the window) efficiently?

####Counting Itemsets
* New Problem: Given a stream, which items appear more than s times in the window?
* Possible solution: Think of the stream of baskets as one binary stream per item
    * 1 = item present; 0 = not present
    * Use **DGIM** to estimate counts of **1**s for all items
<img src=https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.56.15.png>

####Extensions
* In principle, you could count frequent pairs or even larger sets the same way
    * One stream per itemset
    * E.g., for a basket {i, j, k}, assume 7 independent streams: (i) (j) (k) (i, j) (i, k) (j, k) (i, j, k)
    * 그런데 왜  {i, j, k}경우에 7개의 independent streams가 필요한지 모르겠음<p>
* Drawback:
    * Number of itemsets is way too big

####Exponentially Decaying Window
* Exponentially decaying windows: A heuristic for selecting likely frequent item(sets)
    * What are "curently" most popular movies?
        * Instead of computing the raw count in last ***N*** elements
        * Compute a smooth aggregation over the whole stream
* If stream is a_1, a_2, ... and we are taking the sum of the stream, take the answer at time ***t*** to be: = <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.56.26.png" align="center" height="30">
    * c is a constant, presumably tiny, like 10^-6 or 10^-9
* When new a_t+1 arrives:  
    Multiply current sum by **(1-c)** and add a_t+1

####Example: Counting Items
* If each a_i is an "item" we can compute the characteristic function of each possible item ***x*** as an Exponentially Decaying Window
    * That is: <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.56.34.png" align="center" height="30"><br>
    where <img src="https://github.com/bellatoris/Introduction_to_Datamining/blob/master/Picture/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202016-04-10%20%EC%98%A4%ED%9B%84%208.56.49.png" align="center" height="30"> if **a_i = x**, and **0** otherwise
    * Imagine that for each item ***x*** we have a binary stream (**1** if ***x*** appears, **0** if ***x*** does not appear)
    * New item ***x*** arrives:
        * Multiply all counts by **(1 - c)**
        * Add +1 to count for element ***x***
        * ***Remove all items whose weights < s***
