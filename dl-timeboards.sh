dash_id=xxxx
api_key=xxx
app_key=xxx

# dog --pretty timeboard show_all | jq .dashses[].title | wc -l
dog timeboard pull_all <dir>
# ls -1 <dir> | wc -l

# 1. export
curl -X GET "https://app.datadoghq.com/api/v1/dash/${dash_id}?api_key=${api_key}&application_key=${app_key}" > dash.json

# 2. edit dash.json
move "graphs", "title", "description" up one level in the json hierarchy, from being beneath "dash" to being at the same level

# 3. import
curl -X POST -H "Content-type: application/json" -d @dash.json "https://app.datadoghq.com/api/v1/dash?api_key=${api_key}&application_key=${app_key}"
