# Implementation of paper - A Common Variable Minimax Theorem for Graphs
The Implementation of the paper paper -  Coifman, R.R., Marshall, N.F. &amp; Steinerberger, S. A Common Variable Minimax Theorem for Graphs. Found Comput Math (2022). https://doi.org/10.1007/s10208-022-09558-8

## Summarize by – Dan Ilan Ben David

$\mathcal{G}=$ { $G_1=(V,E_1 ),…,G_m=(V,E_m )$ } is a collection of graphs, defined on the same common set of vertices $V$ but with a different edge set $E_k$. This paper wants to find a smooth function $f:V→\Re$ base of the provided graph set of $G$. The paper considers a function to be “smooth” with respect to $G_k$ if $f(u) \approx f(v),∀(u,v)∈E_k$, meaning that every two connected point in $G_k$ are also close in f. This paper tries to define a notion of smoothness under the assumption there exist a good common smooth variable shared by all the graph in $\mathcal{G}$, and try to extract it.

## Introduction:

The paper work on the normalize Laplacian of a graph G, which defined as such:

$$L_{norm}={L\over{λ_1 (L) }}$$

where L is the Laplacian matrix of G and λ_1 is the smallest eigenvalue of L after $λ_0=0$ (the trivial eigenvalue). In order to avoids trivially smooth functions, the paper limit the function to be in $x∈X,X=$ { $x∈R^n:1^T x=0$ and $x^T x=1$}.

The Smoothness score $s_L (x)=x^T L_{norm} x$, that we want to maximize over a combination of all $L_k$ from $\mathcal{G}$. The paper focus on a linear combination like so, to work with eigenvectors of $L_t$ :

$$\varphi_1 (L_{t^\*} ) = argmin_{x∈X}   \max_{t∈T}⁡{s_{L_t} (x)}$$

Where $\varphi_1 (L_{t^\*} )$ is the eigenvector correspond to $λ_1 (L_{t^\* } )$, and:

$$L_t=∑_(k=1)^m〖t_k L_(k_norm) 〗,T≔{t∈[0,1]^m:t_1+⋯+t_m=1}$$

The optimal t^*, can be fine using gradient decent on the function:
t^*=argmax_(t∈T)  λ_1 (L_t )
Because we limited the function x∈X, we want to check the error which resulting from this. In the paper they showed an Upper and Lower Bounds to the problem λ_1 (L_t )≤s_G≤max┬(k∈{1,…,m} )⁡〖s_(L_k ) (φ_1 (L_t ))〗, and by subtracting them we can create an estimate error value of how good our solution is.
