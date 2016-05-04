if "algebra_data.mat" doesn't exist
  run "preprocess_algebra_data.m", run "preprocess_algebra_data_second_step.m"
if 6 "data_newXXXXXX.mat" files don't exist
  run "preprocess_assistments_data.m"
run "main_SB_power_curve.m" to compare high/low level groups with partial credit and binary credit in 6 skill builders of ASSISTments.
run "main_SB_null.m" to compare no-difference groups with partial credit and binary credit in 6 skill builders of ASSISTments.
run "main_interleave_power_curve.m" to compare high/low level groups with partial credit and binary credit in the experimental data.
run "main_interleave_null.m" to compare no-difference groups with partial credit and binary credit in the experimental data.
