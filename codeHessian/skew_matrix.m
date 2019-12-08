function skew_mat = skew_matrix(vec_n)
skew_mat = [     0        -vec_n(3)    vec_n(2) ;
             vec_n(3)        0       -vec_n(1) ;
            -vec_n(2)     vec_n(1)      0      ];