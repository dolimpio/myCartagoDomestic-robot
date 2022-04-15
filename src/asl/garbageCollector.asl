!empty_bucket.

+!emptyBucket : trash_bucket(full)[source(myRobot)] <- 
    empty_bucket(trash);
    .trash_bucket(full)[source(myRobot)]
    !emptyBucket.


+!emptyBucket <- !emptyBucket.