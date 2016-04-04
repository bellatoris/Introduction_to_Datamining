# Introduction_to_Datamining
##Lecture \#6: Mining Data Streams
###Queries Over Sliding Window
##4월 4일
####How to Query?
* To estimate the number of 1s in the most recent N bits:
   1. Sum the sizes of all buckets but the last  
      (note "size" means the number of 1s in the bucket)
   2. Add half the size of the last bucket
* Remember: We do not know how man 1s of the last bucket are still within the wanted window

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
      r = log(N/k)이가 된다. 
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
