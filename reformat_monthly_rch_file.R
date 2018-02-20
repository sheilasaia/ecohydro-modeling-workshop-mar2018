# reformat_montly_rch_file function

# purpose: prepare monthly SWAT .rch file for analysis
# last updated: 2018218
# author: sheila saia
# contact: ssaia [at] ncsu [dot] edu

reformat_monthly_rch_file=function(raw_rch_data) {
  # import monthly raw_rch_data into R session using: 
  # raw_rch_data_raw=read_table2("output.rch", col_names=FALSE, skip=9)
  
  # column names
  rch_col_names=c("file","rch","gis","month","area_km2","flow_in_cms",
                  "flow_out_cms","evap_cms","tloss_cms","sed_in_tons",
                  "sed_out_tons","sed_conc_mgperl","orgn_in_kg","orgn_out_kg",
                  "orgp_in_kg","orgp_out_kg","no3_in_kg","no3_out_kg",
                  "nh4_in_kg","nh4_out_kg","no2_in_kg","no2_out_kg","minp_in_kg",
                  "minp_out_kg","chla_in_kg","chla_out_kg","cbod_in_kg",
                  "cbod_out_kg","disox_in_kg","disox_out_kg","solpst_in_mg",
                  "solpst_out_mg","sorpst_in_mg","sorpst_out_mg","reactpst_mg",
                  "volpst_mg","settlepst_mg","resusppst_mg","diffusepst_mg",
                  "reactbedpst_mg","burypst_mg","bed_pst_mg","bactp_out_ct",
                  "bactlp_out_ct","cmetal_num1_kg","cmetal_num2_kg","cmetal_num3_kg",
                  "totn_kg","totp_kg","no3_conc_megagperl","wtmp_deg_c")
  
  # reassign column names
  colnames(raw_rch_data) = rch_col_names
    
  # label summary columns
  num_years = length(na.omit(unique(raw_rch_data$month)))-12
  rch_data_temp = raw_rch_data %>% 
    select(rch, month:wtmp_deg_c) %>%
    mutate(notes = if_else(month > 12,"summary","not_summary"), year = NA) %>%
    filter(month != (num_years)) # remove annual summary for each subbasin
  
  # for loop to go through rows and pull out years
  num_subs = max(unique(rch_data_temp$rch))
  num_months = 12
  num_per_month = num_subs * num_months
  sim_years = rch_data_temp %>% 
    select(month) %>% 
    distinct() %>% 
    filter(month > 12)
  str = 1
  end = num_per_month
  for (i in 1:length(sim_years$month)) {
    rch_data_temp$year[str:end] = sim_years$month[i]
    str = end + num_subs + 1
    end = str + num_per_month - 1
  }
  
  # final file
  rch_data = rch_data_temp %>% 
    filter(notes == "not_summary") %>%
    select(rch, month, year, area_km2:wtmp_deg_c)
  
  return(rch_data)
}