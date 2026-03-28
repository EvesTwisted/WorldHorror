import requests

url = "https://core-normal.traeapi.us/api/ide/v1/text_to_image"
params = {
    "prompt": "a realistic galaxy with shooting stars and fluffy clouds, panoramic, high resolution",
    "image_size": "landscape_16_9"
}

response = requests.get(url, params=params)

if response.status_code == 200:
    with open("d:\\WorldHorror\\scenes\\world\\galaxy_sky.png", "wb") as f:
        f.write(response.content)
else:
    print(f"Error: {response.status_code}")
