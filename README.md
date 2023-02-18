# qr-halfup-rounding

Quotient-remainder half up rounding algorithm, implemented as an 8086 program
for the '_Computer architectures_' course at PoliTO.

## Problem

Consider the unsigned integer division Q = X / D and let R be the remainder; it holds that
X = Q * D + R, with 0 <= R < D. What if we're interested in rounding up the result?
A straightforward approach is to translate the definition of half up rounding
taking advantage of the properties of the binary representation. Being Q the integer part
of the result, if we have the most significant bit of the  fractional part, say y,
then it holds: round(Q.y) = Q + y. In fact, we can observe that y has a 2^(-1) weight
in the representation. However, the disadvantage is that computing this y bit requires
to execute an additional division.

## Algorithm

To avoid the additional division, we have to find a way of directly working with Q, R and D.
In the field of reals the algorithm could be: round(Q, R) = (R >= D/2) ? (Q+1) : (Q+0).
Again, it's now a matter of exploiting properties of the binary representation:

1. being D>0, floor(D/2) is computed efficiently with a logic shift right. The LSB of D
   goes into the carry flag CF: it is '0' when D is even and '1' otherwise.

2. When D is
   * even, then 
       * R in {0, ..., floor(D/2)-1} implies round(Q, R) = Q+0
       * R in {floor(D/2), ..., D-1} implies round(Q, R) = Q+1 
       * To generate the bit to be added to Q for rounding, a possibility is to exploit
         the knowledge of the set R belongs to and compute an auxiliary variable whose
         sign gives the bit of interest. Specifically, the MSB of (floor(D/2)-1)-R satisfies
         this criterion.
   
   * odd, then
       * R in {0, ..., floor(D/2)} implies round(Q, R) = Q+0
       * R in {floor(D/2)+1, ..., D-1} implies round(Q, R) = Q+1
       * Applying the same idea, the MSB of (floor(D/2)-0)-R satisfies this criterion.

3. Overall, the auxiliary variable can be computed as: (floor(D/2) - !CF) - R,
   where !CF is the complemented carry flag coming from the logic shift right operation.

### Signedness

Taking advantage of the 2's complement properties, the exact same algorithm can also be used
when the dividend is a signed integer, as long as D>0 and 0 <= R < D.

## Implementation

For simplicity, I consider a 16-bit by 8-bit unsigned division, I ignore the possible overflow
and I assume that the dividend X, the divisor D and the rounded quotient Q are memory operands.