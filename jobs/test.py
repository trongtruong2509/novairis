from datetime import datetime, timedelta
import requests
import json

def get_ab_conn_id(ds=None, **kwargs):
    username = "pieter"  # Replace with actual username
    password = "Testpass2024"  # Replace with actual password
    ab_url = "https://68.183.188.131:8100/api/v1"
    headers = {"Accept": "application/json", "Content-Type": "application/json"}
    auth = (username, password)

    workspace_id = requests.post(
        f"{ab_url}/workspaces/list", 
        headers=headers,
        auth=auth,
        verify=False  # Remove this if using valid SSL cert
    ).json().get("workspaces")[0].get("workspaceId")

    payload = json.dumps({"workspaceId": workspace_id})
    connections = requests.post(
        f"{ab_url}/connections/list", 
        headers=headers, 
        data=payload,
        auth=auth,
        verify=False  # Remove this if using valid SSL cert
    ).json().get("connections")

    for c in connections:
        if c.get("name") == "demo-con":
            return c.get("connectionId")
        

id = get_ab_conn_id()

print(f"id is: {id}")