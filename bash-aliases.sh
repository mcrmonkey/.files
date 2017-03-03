alias dl='curl --silent -w "DNS:\t\t%{time_namelookup}\nConnect:\t%{time_connect}\nPretransfer:\t%{time_pretransfer}\nRedirect:\t%{time_redirect}\nStart Transfer: %{time_starttransfer}\n------------------------\nTotal:\t\t%{time_total}\n" --output /dev/null'


