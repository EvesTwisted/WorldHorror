@tool
extends EditorPlugin

var http_request: HTTPRequest

func _ready() -> void:
    http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.set_use_threads(true)
    http_request.set_tls_options(TLSOptions.client_untrusted()) # Temporary for development
    http_request.request_completed.connect(_on_request_completed)

    # Example of how to use it:
    # download_material("Wood049")

func download_material(material_id: String) -> void:
    var url = "https://ambientcg.com/api/v2/full_json?id=" + material_id
    if not url.begins_with("https"):
        print("URL is not HTTPS, aborting.")
        return

    var error = http_request.request(url)
    if error != OK:
        print("An error occurred in the HTTP request.")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
    if result != HTTPRequest.RESULT_SUCCESS:
        print("Request failed.")
        return

    if response_code == 200:
        var json = JSON.new()
        var error = json.parse(body.get_string_from_utf8())
        if error == OK:
            var data = json.get_data()
            print("Downloaded data: ", data)
        else:
            print("Failed to parse JSON.")
    else:
        print("Request failed with code: ", response_code)
