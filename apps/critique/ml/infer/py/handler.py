import json
import requests
import runpod
import time

print("Loading function")

def handler(event):
    print(f"Received event: #{event}")
    input = event['input']
    url = "http://localhost:4001/"
    retries = 3
    sleep_interval = 3

    for i in range(retries):
        try:
            response = requests.post(
                url,
                data=json.dumps(input),
                headers={'Content-Type':'application/json'}
            )
            print(response)
            if response.ok and response.status_code == 200:
                return response.json()
            else:
                print(f"Request failed with status code: {response.status_code}. Retrying in {sleep_interval} seconds...")
                time.sleep(sleep_interval)
        except requests.exceptions.RequestException as err:
            print(f"Request error: {err}. Retrying in {sleep_interval} seconds...")
            time.sleep(sleep_interval)

    return {'error': 'Maximum retries exceeded'}

runpod.serverless.start({
    "handler": handler
})
