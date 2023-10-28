def json_body
  JSON.parse(response.body)
end

def json_response
  json_body["data"]
end

def json_meta
  json_body["meta"]
end
