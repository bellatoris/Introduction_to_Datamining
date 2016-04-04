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
   1 + 2 + 4 + ... + 2^(r - 1) = 2^r - 1 (실제로는 각 si
* Thus error is at most 50%
