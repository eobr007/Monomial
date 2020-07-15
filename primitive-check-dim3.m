AttachSpec ("spec");
import "classes.m": PrimitiveClasses;
import "s-modules.m": SparseToStandard;

load "checks/schur.m";

// convert from sparse to standard, check order is m
StandardGroups := function (X, m: Bound := 5000)
   L1 := [];
   S := [];
   for i in [1..#X] do
      F := BaseRing (X[i]);
      if CyclotomicOrder (F) lt Bound then
         G := SparseToStandard (X[i]);
      else
         G := X[i];
      end if;
      Append (~L1, G);
      f, I := IsomorphicCopy (G);
      o := LMGOrder (I);
      assert o eq m;
      Append (~S, I);
   end for;
   return L1, S;
end function;




// no group id available
PrimitiveHardCase := function (p, m)

X := PrimitiveClasses (3, m: Insoluble := false);
Y := StandardGroups (X, m);
I := [PCGroup (H) where _, H := IsomorphicCopy (y): y in Y];
Z, pos := DifferentOnes (I, IsIsomorphic);

N := [];
for j in pos do
   L := [j];
   for i in [j + 1..#Y] do
      if IsIsomorphic (I[j], I[i]) then Append (~L, i); end if;
    end for;
    Append (~N, #L);
end for;
"Now N is ", N;

for i in [1..#Z] do
   J := Z[i];
   // if HasMonomialReps (J) eq false then 
   n:=NumberOfReps (J, p);
   i, N[i], n;
   assert N[i] eq n;
   // end if;
end for;

return true;
end function;


for m in 
[ 108, 216, 324, 432, 540, 648, 756, 864, 972, 1080, 1188, 1296, 1404, 1512, 
1620, 1728, 1836, 1944 ] do 

"\n\n Order = ", m;

X := PrimitiveClasses (3, m: Insoluble := false);
ids := [IdentifyGroup (x): x in X];
"Set of ids is ", Multiset (ids);
flag := forall{x :x in X | #x eq m};
if not flag then 
   "*** error orders";
   continue;
end if;

assert forall{x :x in X | #x div #Centre (x) in {36, 72, 216}};

S := SmallGroups (m);
T := [x : x in S | IsSoluble (x)];
index := [i: i in [1..#S] | HasMonomialReps (S[i])];
J := {1..NumberOfSmallGroups (m)} diff Set (index);
J := [x : x in J];
Sort (~J);
"Possible ids are ", #J;
N := [NumberOfReps (SmallGroup (m, i), 3): i in J];
"Number of prim reps ", N;
"Number of iso types having prim reps", #[x :x in N | x ne 0];
"Total number is ", &+N;
assert &+N eq #X;

end for;


/* 
p := 3; 
for m in [2001..40000] do
if m mod 108 ne 0 then continue; end if;
"m is", m;
PrimitiveHardCase (p, m);
end for;

*/