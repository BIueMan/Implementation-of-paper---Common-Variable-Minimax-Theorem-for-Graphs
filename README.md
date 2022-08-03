# Implementation of paper - A Common Variable Minimax Theorem for Graphs
The Implementation of the paper paper -  Coifman, R.R., Marshall, N.F. &amp; Steinerberger, S. A Common Variable Minimax Theorem for Graphs. Found Comput Math (2022). https://doi.org/10.1007/s10208-022-09558-8

## Summarize by – Dan Ilan Ben David

$\mathcal{G}=$ { $G_1=(V,E_1 ),…,G_m=(V,E_m )$ } is a collection of graphs, defined on the same common set of vertices $V$ but with a different edge set $E_k$. This paper wants to find a smooth function $f:V→\Re$ base of the provided graph set of $G$. The paper considers a function to be “smooth” with respect to $G_k$ if $f(u) \approx f(v),∀(u,v)∈E_k$, meaning that every two connected point in $G_k$ are also close in f. This paper tries to define a notion of smoothness under the assumption there exist a good common smooth variable shared by all the graph in $\mathcal{G}$, and try to extract it.

## Introduction:

The paper work on the normalize Laplacian of a graph G, which defined as such:

$$L_{norm}={L\over{λ_1 (L) }}$$

where L is the Laplacian matrix of $G$ and $λ_1$ is the smallest eigenvalue of L after $λ_0=0$ (the trivial eigenvalue). In order to avoids trivially smooth functions, the paper limit the function to be in $x∈X,X=$ { $x∈R^n:1^T x=0$ and $x^T x=1$}.

The Smoothness score $s_L (x)=x^T L_{norm} x$, that we want to maximize over a combination of all $L_k$ from $\mathcal{G}$. The paper focus on a linear combination like so, to work with eigenvectors of $L_t$ :

$$\varphi_1 (L_{t^\*} ) = argmin_{x∈X}   \max_{t∈T}⁡{s_{L_t} (x)}$$

Where $\varphi_1 (L_{t^\*} )$ is the eigenvector correspond to $λ_1 (L_{t^\* } )$, and:

$$L_t=\sum_{k=1}^m {t_k L_{k_norm}},  T≔ [ t∈[0,1]^m:t_1+⋯+t_m=1 ] $$

The optimal $t^\*$, can be fine using gradient decent on the function:

$$t^\*=argmax_{t∈T}  λ_1 (L_t )$$

Because we limited the function $x∈X$, we want to check the error which resulting from this. In the paper they showed an Upper and Lower Bounds to the problem $λ_1 (L_t )≤s_{\mathcal{G}}≤\max_{k∈[1,…,m]}⁡{s_{L_k} (\varphi_1 (L_t )})$, and by subtracting them we can create an estimate error value of how good our solution is.

## Examples and results:

In the code, we have implemented the first 3 examples shown in this paper. To create $\mathcal{G}$, we first create a random set of point $V$ and a graph of 6 nearest neighbors in $l_2 (6-nn), G_1=(V,E_k )$. All future graphs $(G_k )$ are use a shifting function to relocate the point $V$, and then calculate the 6-nn, in order to create a $E_k$ (see the figures explanation for full construction of the examples and expectation of what results we will get). For every example we plot the $\mathcal{G}, λ_1 (L_t )$ to find $t^\*$ and the optimal function.

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%201.png)

### Example 1
**Figure 1** – $G_1$  and $G_2$ are a 6-nearest neighbor graph of the same random points. when G_1 the point is located normal random around $|x|,|y|≤0.5$. and $G_2$ use the same point that have been independently randomly rotated the origin.

**Note:** the point keeps the same distance from the origin (r), and we expect to have a strong correlation between the graphs in that regard.

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%202.png)

**Figure 2** – the plot is a product of the value of the smallest nontrivial eigenvalue of $L_t$, which is a linear combination of the normalize Laplacian of $G_1,G_2$. We assume that the function we extract from $L_t$, will corelate to the distance of the point from the origin.
In this case, t = (0.5320    0.4680), with error estimating of 1.3966e-06.

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%203.png)

**Figure 3** – we plot the function $φ_1$ correlate to the $λ_1$ for both $L_t,L_1,L_2$, against their distance from the origin. we can see that $φ_1 (L_t )$ have a strong correlation between it and the distance from the origin as we expected. Will for $φ_1 (L_1 ),φ_1 (L_2 )$, there is not enough information to extract that information.

### Example 2

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%204.png)

**Figure 4** – for the second part of the paper, we create a 3D connection graphs, of 6-nn. $G_1$ is a 6-nn graph with points spared in uniform random sphere $(r,ϕ,η)$ where $r≤1,ϕ∈[0,2π],η∈[0,π]$. $G_2$ points use the point of $G_1$ with randomly rotated on the $(x,y)$ axis, will keeping the same distance from the origin. And $G_2$ on the $(x,z)$ axis. We expect the strong correlated to the distance from the origin like before.

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%205.png)

**Figure 5** – like before, the plot is a product of the $λ_1 (L_t )$, of matrix $L_t (t_1,t_2 )  [t_3=1-t_1-t_2 ]$ which is a linear combination of the normalize Laplacian of $G_1,G_2,G_3$.
The maxima full under - t = (0.3341    0.4370    0.2289) with an error estimation of 1.1492e-05.

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%206.png)

**Figure 6** – we plot the function $φ_1$  correlate to the $λ_1$ for both $L_t,L_1,L_2,L_3$, against the distance from the origin. We can clearly see a strong correlation between the distance and $φ_1 (L_t )$ as we expected.

## Example 3

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%207.png)

**Figure 7** – on the third part of the paper, we create a 2D connection graphs, of 6-nn. $G_1$ have it points spared in normal random in a polar shape $(r,ϕ)$ when $r≤1,ϕ∈[0,2π]$. $G_2$  and $G_3$ manipulate the points like so: $X_2=f(X_1 ),f(x,y)=(x,y(1-\cos{⁡πx} )),X_3=f(X_1 ),f(x,y)=(x(1-\cos⁡{πy} ),y)$. Where $X1,X2,X3$ are the points of $G_1,G_2,G_3$.

**Note:** this time there is a strong separation between the sign of the points in the x axis (in G_2) and sign of in the y axis (in G_3), so we expect a strong separation between the 4 Quarters.

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%208.png)

**Figure 8** – this time, the maximum occurs on t = (0.0000    0.4874    0.5126) with an error estimation of 4.6823e-04, we can see there is no uses of the Laplacian $L_1$. It seems using the Laplacians $L_2,L_3$  give as the strongest correlation for the first nontrivial eigenvalue.

**Note:** next we going 2 extract the tree most dominant function from $L_t$ and plot them as point in a 3D space.

![alt text](https://github.com/BIueMan/Implementation-of-paper---Common-Variable-Minimax-Theorem-for-Graphs/blob/main/images/figure%209.png)

**Figure 9** – we plot the function of the points in a 3D space, with the corresponding $L_{t^\* }$ we found before. We split the points base of their location on $G_1$ (NE, NW, SW, SE). 




## Review

We created the examples in a specific way that give us a distinct common attribute between the graphs (like in example 1,2), or opposite attribute between the graph (like in example 3). The model extracts those attributes really good, and even manages to use only the most significant graphs.
The first problem that arises is the selection of $t$, we selection it will only looking at the first eigenvalue of $L_t$. That is a logical solution because it bases on the most dominant function over all of $\mathcal{G}$. But what if the attribute is spared over a pair of different graphs. We can get more than one local maxima, and the algorithm will converge only on one of them, but miss the other.

## Extension:

The paper recommends more ways to calculate $L_t$, and I tend to agree. We can choose the function $L_t$ base of what we expect to get, or choose the one that gives you the best results. In addition, trying to take into account not just the strongest eigenvalue, but all the local maxima. Can help us extract different information from different point of $t$. 

