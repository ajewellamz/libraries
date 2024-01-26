// RUN: %verify "%s"

/*******************************************************************************
 *  Original Copyright under the following: 
 *  Copyright 2018-2021 VMware, Inc., Microsoft Inc., Carnegie Mellon University, 
 *  ETH Zurich, and University of Washington
 *  SPDX-License-Identifier: BSD-2-Clause 
 * 
 *  Copyright (c) Microsoft Corporation
 *  SPDX-License-Identifier: MIT 
 * 
 *  Modifications and Extensions: Copyright by the contributors to the Dafny Project
 *  SPDX-License-Identifier: MIT 
 *******************************************************************************/

include "../../Functions.dfy"

module {:options "-functionSyntax:4"} Isets {

  import opened Functions

  /* If all elements in iset x are in iset y, x is a subset of y. */
  lemma LemmaSubset<T>(x: iset<T>, y: iset<T>)
    requires forall e {:trigger e in y} :: e in x ==> e in y
    ensures x <= y
  {
  }

  /* Map an injective function to each element of an iset. */
  ghost function {:opaque} Map<X(!new), Y>(xs: iset<X>, f: X --> Y): (ys: iset<Y>)
    requires forall x :: f.requires(x)
    requires Injective(f)
    reads f.reads
    ensures forall x {:trigger f(x)} :: x in xs <==> f(x) in ys
  {
    var ys := iset x | x in xs :: f(x);
    ys
  }

  /* Construct an iset using elements of another set for which a function
  returns true. */
  ghost function {:opaque} Filter<X(!new)>(xs: iset<X>, f: X ~> bool): (ys: iset<X>)
    requires forall x :: x in xs ==> f.requires(x)
    reads set x, o | x in xs && o in f.reads(x) :: o
    ensures forall y {:trigger f(y)}{:trigger y in xs} :: y in ys <==> y in xs && f(y)
  {
    var ys := iset x | x in xs && f(x);
    ys
  }

}
