(
~dataVars = ["BEHRNO2", "O3_tVCD", "O3_VMR"];
~site_stats = ~generate_all_site_stats.(~locations, ~dataVars);
~category_stats = ~generate_type_stats.(~locations, ~dataVars);
~global_stats = ~generate_global_stats.(~locations, ~dataVars);
"Generated site-by-site and global statistics (trend_statistics.scd)".postln;
)