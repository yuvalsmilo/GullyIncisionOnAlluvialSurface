# GullyIncisionOnAlluvialSurface

Inverse incision topographic profile to age can be set in the following ways:

Optimize erosion model parameters using optimization_main.m file:
  This function search for the optimal erosion model parameters that minimize the fit of initial topographic profile to obesrved gully profile. The total run time is defined by the user.
  The comparison between simulated and measured gully profile relies on an objective function that transforms the elevation differences between modeled and simulated profiles into a scalar (RMSD)
Inverse gully profile to incision age using solvefortime_main.m file:
  This function calculate the RMSD between simulated gully profile given and measured gully profile for various run-times.
  The time with the lower RMSD is bestly represent the incision age given the specific parameter combination
